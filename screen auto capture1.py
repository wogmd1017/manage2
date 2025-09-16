import os, cv2, mss, numpy as np, threading, time
from datetime import datetime
import tkinter as tk
from tkinter import messagebox
import win32gui  # Windows 창 제어 API

# ------- 전역 변수 --------
recording = False
capture_thread = None
video_writer = None
output_path = None
stop_timer = None
auto_stop_enabled = None
remaining_time_label = None
countdown_thread = None

AUTO_STOP_SECONDS = 45 * 60   # 45분 자동 종료 시간
CAPTURE_INTERVAL = 3          # 3초마다 캡처
WINDOW_TITLE = "클라우드스쿨 매니져"  # 캡처할 창 이름

# ------- 창 영역 찾기 --------
def get_window_rect(title):
    hwnd = win32gui.FindWindow(None, title)
    if hwnd == 0:
        return None
    rect = win32gui.GetWindowRect(hwnd)
    x1, y1, x2, y2 = rect
    return {"left": x1, "top": y1, "width": x2 - x1, "height": y2 - y1}

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

# ------- GUI --------
def gui_app():
    global auto_stop_enabled, remaining_time_label
    root = tk.Tk()
    root.title("클라우드스쿨 녹화 도구")

    start_btn = tk.Button(root, text="녹화 시작", command=start_recording, width=20)
    start_btn.pack(pady=10)

    stop_btn = tk.Button(root, text="녹화 정지", command=stop_recording, width=20)
    stop_btn.pack(pady=10)

    auto_stop_enabled = tk.BooleanVar(value=True)
    chk = tk.Checkbutton(root, text="자동 종료 (45분)", variable=auto_stop_enabled)
    chk.pack(pady=5)

    remaining_time_label = tk.Label(root, text="대기 중...")
    remaining_time_label.pack(pady=10)

    root.mainloop()

if __name__ == "__main__":
    gui_app()