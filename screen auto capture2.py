import os, cv2, mss, numpy as np, threading, time
from datetime import datetime
import tkinter as tk
from tkinter import messagebox, ttk  # ttk 추가 (콤보박스)
import win32gui

# ------- 전역 변수 --------
recording = False
capture_thread = None
video_writer = None
output_path = None
stop_timer = None
auto_stop_enabled = None
remaining_time_label = None
countdown_thread = None

AUTO_STOP_SECONDS = 45 * 60
CAPTURE_INTERVAL = 3
WINDOW_TITLE = "클라우드스쿨 매니져"

# 예약 저장 리스트
schedules = []   # 예: [("Mon","09:30"), ("Tue","13:00")]

# ------- 창 영역 찾기 --------
def get_window_rect(title):
    hwnd = win32gui.FindWindow(None, title)
    if hwnd == 0:
        return None
    rect = win32gui.GetWindowRect(hwnd)
    x1, y1, x2, y2 = rect
    return {"left": x1, "top": y1, "width": x2-x1, "height": y2-y1}

# ------- 저장 경로 --------
def get_save_path():
    desktop = os.path.join(os.path.expanduser("~"), "Desktop", "data")
    today = datetime.now().strftime("%Y-%m-%d")
    folder = os.path.join(desktop, today)
    os.makedirs(folder, exist_ok=True)
    filename = datetime.now().strftime("%H-%M-%S") + ".mp4"
    return os.path.join(folder, filename)

# ------- 자동 종료 --------
def auto_stop():
    if recording:
        stop_recording()
        messagebox.showinfo("알림", "⏰ 45분 자동 제한으로 녹화를 종료했습니다.")

# ------- 카운트다운 --------
def start_countdown():
    global countdown_thread
    def run():
        remaining = AUTO_STOP_SECONDS
        while recording and auto_stop_enabled.get() and remaining > 0:
            mins, secs = divmod(remaining, 60)
            remaining_time_label.config(text=f"남은 시간: {mins:02d}:{secs:02d}")
            time.sleep(1)
            remaining -= 1
        if not auto_stop_enabled.get() and recording:
            remaining_time_label.config(text="남은 시간: 제한 없음")
    countdown_thread = threading.Thread(target=run, daemon=True)
    countdown_thread.start()

# ------- 녹화 시작 --------
def start_recording():
    global recording, capture_thread, video_writer, output_path, stop_timer
    if recording:
        return
    
    region = get_window_rect(WINDOW_TITLE)
    if not region:
        messagebox.showerror("오류", f"창을 찾을 수 없습니다: {WINDOW_TITLE}")
        return

    output_path = get_save_path()
    fourcc = cv2.VideoWriter_fourcc(*"mp4v")
    video_writer = cv2.VideoWriter(output_path, fourcc, 1.0, (region["width"], region["height"]))
    
    recording = True
    capture_thread = threading.Thread(target=capture_loop, args=(region,), daemon=True)
    capture_thread.start()
    print(f"녹화 시작: {output_path}")

    if auto_stop_enabled.get():
        stop_timer = threading.Timer(AUTO_STOP_SECONDS, auto_stop)
        stop_timer.start()
        start_countdown()
    else:
        remaining_time_label.config(text="남은 시간: 제한 없음")

# ------- 녹화 정지 --------
def stop_recording():
    global recording, video_writer, stop_timer
    if not recording: return
    
    recording = False
    if video_writer:
        video_writer.release()
        video_writer = None
    if stop_timer:
        stop_timer.cancel()
        stop_timer = None
    remaining_time_label.config(text="녹화 종료됨")
    print("녹화 정지")

# ------- 캡처 루프 --------
def capture_loop(region):
    global recording, video_writer
    with mss.mss() as sct:
        while recording:
            img = np.array(sct.grab(region))
            frame = cv2.cvtColor(img, cv2.COLOR_BGRA2BGR)
            video_writer.write(frame)
            time.sleep(CAPTURE_INTERVAL)

# ------- 예약 관리 --------
def add_schedule(day, time_str, listbox):
    if not time_str or ":" not in time_str:
        messagebox.showerror("입력 오류", "시간 형식은 HH:MM 이어야 합니다.")
        return
    schedules.append((day, time_str))
    listbox.insert(tk.END, f"{day} {time_str}")
    print("예약 추가:", day, time_str)

def remove_schedule(listbox):
    sel = listbox.curselection()
    if not sel: return
    index = sel[0]
    listbox.delete(index)
    schedules.pop(index)

def schedule_checker():
    """실시간 예약 체크 스레드"""
    while True:
        now = datetime.now()
        current_day = now.strftime("%a")  # Mon, Tue, ...
        current_time = now.strftime("%H:%M")
        for day, t in schedules:
            if day == current_day and t == current_time and not recording:
                print("예약 녹화 실행:", day, t)
                start_recording()
        time.sleep(30)  # 30초마다 확인

# ------- GUI --------
def gui_app():
    global auto_stop_enabled, remaining_time_label
    root = tk.Tk()
    root.title("클라우드스쿨 녹화 도구")

    start_btn = tk.Button(root, text="녹화 시작", command=start_recording, width=20)
    start_btn.pack(pady=5)

    stop_btn = tk.Button(root, text="녹화 정지", command=stop_recording, width=20)
    stop_btn.pack(pady=5)

    auto_stop_enabled = tk.BooleanVar(value=True)
    chk = tk.Checkbutton(root, text="자동 종료 (45분)", variable=auto_stop_enabled)
    chk.pack(pady=5)

    remaining_time_label = tk.Label(root, text="대기 중...")
    remaining_time_label.pack(pady=5)

    # 예약 관리 UI
    frame = tk.LabelFrame(root, text="예약 관리")
    frame.pack(pady=10, fill="x")

    tk.Label(frame, text="요일:").pack()
    day_combo = ttk.Combobox(frame, values=["Mon","Tue","Wed","Thu","Fri","Sat","Sun"])
    day_combo.set("Mon")
    day_combo.pack()

    tk.Label(frame, text="시간 (HH:MM):").pack()
    time_entry = tk.Entry(frame)
    time_entry.pack()

    listbox = tk.Listbox(frame, height=6)
    listbox.pack(pady=5, fill="x")

    add_btn = tk.Button(frame, text="추가", 
                        command=lambda: add_schedule(day_combo.get(), time_entry.get(), listbox))
    add_btn.pack(side="left", padx=5)

    del_btn = tk.Button(frame, text="삭제", 
                        command=lambda: remove_schedule(listbox))
    del_btn.pack(side="right", padx=5)

    # 예약 확인 스레드
    th = threading.Thread(target=schedule_checker, daemon=True)
    th.start()

    root.mainloop()

if __name__ == "__main__":
    gui_app()