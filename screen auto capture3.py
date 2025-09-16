import os, cv2, mss, numpy as np, threading, time, csv
from datetime import datetime
import tkinter as tk
from tkinter import messagebox, filedialog
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
WINDOW_TITLES = ["클라우드스쿨 매니져", "클라우드 스쿨 교사용"]

schedules = []  # [("Mon","09:30"), ...]
SCHEDULE_FILE = "schedules.csv"

# ------- 창 영역 찾기 --------
def get_window_rect():
    for title in WINDOW_TITLES:
        hwnd = win32gui.FindWindow(None, title)
        if hwnd != 0:
            rect = win32gui.GetWindowRect(hwnd)
            x1, y1, x2, y2 = rect
            return {"left": x1, "top": y1, "width": x2-x1, "height": y2-y1}
    return None

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
    
    region = get_window_rect()
    if not region:
        messagebox.showerror("오류", f"창을 찾을 수 없습니다: {WINDOW_TITLES}")
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

    # 요일+시간 오름차순 정렬
    schedules.sort(key=lambda x: (["Mon","Tue","Wed","Thu","Fri","Sat","Sun"].index(x[0]),
                                  int(x[1].split(":")[0])*60 + int(x[1].split(":")[1])))

    # 리스트박스 갱신
    listbox.delete(0, tk.END)
    for d, t in schedules:
        listbox.insert(tk.END, f"{d} {t}")

    save_schedules()

def remove_schedule(listbox):
    sel = listbox.curselection()
    if not sel: return
    index = sel[0]
    listbox.delete(index)
    schedules.pop(index)
    save_schedules()

def schedule_checker():
    while True:
        now = datetime.now()
        current_day = now.strftime("%a")
        current_time = now.strftime("%H:%M")
        for day, t in schedules:
            if day == current_day and t == current_time and not recording:
                print("예약 녹화 실행:", day, t)
                start_recording()
        time.sleep(30)

def save_schedules():
    with open(SCHEDULE_FILE, "w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerows(schedules)

def load_schedules(listbox):
    if not os.path.exists(SCHEDULE_FILE):
        return
    with open(SCHEDULE_FILE, "r", encoding="utf-8") as f:
        reader = csv.reader(f)
        for row in reader:
            if len(row) == 2:
                schedules.append((row[0], row[1]))
                listbox.insert(tk.END, f"{row[0]} {row[1]}")

def export_schedules():
    file = filedialog.asksaveasfilename(defaultextension=".csv", 
                                        filetypes=[("CSV 파일","*.csv"),("모든 파일","*.*")])
    if not file: return
    with open(file, "w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerows(schedules)
    messagebox.showinfo("완료", f"예약을 내보냈습니다.\n{file}")

def import_schedules(listbox):
    file = filedialog.askopenfilename(filetypes=[("CSV 파일","*.csv"),("모든 파일","*.*")])
    if not file: return
    with open(file, "r", encoding="utf-8") as f:
        reader = csv.reader(f)
        schedules.clear()
        listbox.delete(0, tk.END)
        for row in reader:
            if len(row) == 2:
                schedules.append((row[0], row[1]))
                listbox.insert(tk.END, f"{row[0]} {row[1]}")
    save_schedules()
    messagebox.showinfo("완료", f"예약을 불러왔습니다.\n{file}")

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
    frame.pack(pady=10, fill="both", expand=True)

    # 요일 라디오 버튼
    tk.Label(frame, text="요일:").pack()
    day_var = tk.StringVar(value="Mon")
    days = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
    day_frame = tk.Frame(frame)
    day_frame.pack()
    for d in days:
        tk.Radiobutton(day_frame, text=d, value=d, variable=day_var).pack(side="left")

    tk.Label(frame, text="시간 (HH:MM):").pack()
    time_entry = tk.Entry(frame)
    time_entry.pack()

    # 리스트박스
    list_frame = tk.Frame(frame)
    list_frame.pack(pady=5, fill="both", expand=True)
    scrollbar = tk.Scrollbar(list_frame, orient="vertical")
    listbox = tk.Listbox(list_frame, height=12, yscrollcommand=scrollbar.set)
    scrollbar.config(command=listbox.yview)
    scrollbar.pack(side="right", fill="y")
    listbox.pack(side="left", fill="both", expand=True)

    # 시간 엔터 입력 이벤트
    def on_time_enter(event):
        add_schedule(day_var.get(), time_entry.get(), listbox)
        time_entry.delete(0, tk.END)

    time_entry.bind("<Return>", on_time_enter)

    add_btn = tk.Button(frame, text="추가", 
                        command=lambda: add_schedule(day_var.get(), time_entry.get(), listbox))
    add_btn.pack(side="left", padx=5)

    del_btn = tk.Button(frame, text="삭제", 
                        command=lambda: remove_schedule(listbox))
    del_btn.pack(side="left", padx=5)

    exp_btn = tk.Button(frame, text="내보내기", command=export_schedules)
    exp_btn.pack(side="left", padx=5)

    imp_btn = tk.Button(frame, text="불러오기", command=lambda: import_schedules(listbox))
    imp_btn.pack(side="left", padx=5)

    # 기존 예약 불러오기
    load_schedules(listbox)

    # 예약 확인 스레드
    th = threading.Thread(target=schedule_checker, daemon=True)
    th.start()

    root.mainloop()

if __name__ == "__main__":
    gui_app()
