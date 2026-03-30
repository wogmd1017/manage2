import os, cv2, mss, numpy as np, threading, time, csv, subprocess
from datetime import datetime
import tkinter as tk
from tkinter import messagebox, filedialog
import win32gui

# ------- [1. 경로 및 설정] --------
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
RCLONE_EXE = os.path.join(BASE_DIR, "rclone.exe")
RCLONE_CONF = os.path.join(BASE_DIR, "rclone.conf")

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
WINDOW_TITLES = ["AI 스마트클래스", "AI 클래스"]
schedules = []
SCHEDULE_FILE = os.path.join(BASE_DIR, "schedules.csv")

# ------- [2. 창 영역 찾기] --------
def get_window_rect():
    for title in WINDOW_TITLES:
        hwnd = win32gui.FindWindow(None, title)
        if hwnd != 0:
            rect = win32gui.GetWindowRect(hwnd)
            x1, y1, x2, y2 = rect
            return {"left": x1, "top": y1, "width": x2-x1, "height": y2-y1}
    return None

# ------- [3. 파일명 및 경로 생성 (시분초+교시)] --------
def get_save_info():
    now = datetime.now()
    date_str = now.strftime("%Y%m%d")
    time_str = now.strftime("%H%M%S") # 시분초 추가
    year_log_dir = now.strftime("%Y_Log")
    
    cur_hm = int(now.strftime("%H%M"))
    if cur_hm < 955: prd = "P1"
    elif cur_hm < 1050: prd = "P2"
    elif cur_hm < 1145: prd = "P3"
    elif cur_hm < 1330: prd = "P4"
    elif cur_hm < 1425: prd = "P5"
    elif cur_hm < 1520: prd = "P6"
    elif cur_hm < 1615: prd = "P7"
    else: prd = "After"
    
    local_folder = os.path.join(BASE_DIR, year_log_dir)
    if not os.path.exists(local_folder):
        os.makedirs(local_folder)
    
    file_name = f"{date_str}_{time_str}_{prd}.mp4"
    full_path = os.path.join(local_folder, file_name)
    return full_path, year_log_dir, file_name

# ------- [4. 구글 드라이브 업로드] --------
def upload_to_gdrive(local_path, remote_dir, file_name):
    if not os.path.exists(RCLONE_CONF):
        print("rclone.conf 없음")
        return

    remote_path = f"gdrive:/data/{remote_dir}/{file_name}"
    cmd = [RCLONE_EXE, "--config", RCLONE_CONF, "copyto", local_path, remote_path, "--update"]
    
    def run_upload():
        try:
            # CREATE_NO_WINDOW (0x08000000) 옵션으로 검은 창 방지
            subprocess.run(cmd, check=True, creationflags=0x08000000)
            print(f"업로드 완료: {file_name}")
        except:
            print(f"업로드 실패: {file_name}")

    threading.Thread(target=run_upload, daemon=True).start()

# ------- [5. 녹화 로직] --------
def auto_stop():
    if recording:
        stop_recording()
        messagebox.showinfo("알림", "⏰ 45분 자동 제한으로 녹화를 종료했습니다.")

def start_countdown():
    def run():
        remaining = AUTO_STOP_SECONDS
        while recording and auto_stop_enabled.get() and remaining > 0:
            mins, secs = divmod(remaining, 60)
            remaining_time_label.config(text=f"남은 시간: {mins:02d}:{secs:02d}")
            time.sleep(1)
            remaining -= 1
        if not auto_stop_enabled.get() and recording:
            remaining_time_label.config(text="남은 시간: 제한 없음")
    threading.Thread(target=run, daemon=True).start()

def start_recording():
    global recording, video_writer, output_path, stop_timer, cur_remote_dir, cur_file_name
    if recording: return
    
    region = get_window_rect()
    if not region:
        messagebox.showerror("오류", "녹화할 창을 찾을 수 없습니다.")
        return

    output_path, cur_remote_dir, cur_file_name = get_save_info()
    fourcc = cv2.VideoWriter_fourcc(*"mp4v")
    video_writer = cv2.VideoWriter(output_path, fourcc, 1.0, (region["width"], region["height"]))
    
    recording = True
    threading.Thread(target=capture_loop, args=(region,), daemon=True).start()
    
    if auto_stop_enabled.get():
        stop_timer = threading.Timer(AUTO_STOP_SECONDS, auto_stop)
        stop_timer.start()
        start_countdown()
    else:
        remaining_time_label.config(text="남은 시간: 제한 없음")

def stop_recording():
    global recording, video_writer, stop_timer
    if not recording: return
    
    recording = False
    if video_writer:
        video_writer.release()
        video_writer = None
        # 업로드 실행
        upload_to_gdrive(output_path, cur_remote_dir, cur_file_name)
        
    if stop_timer:
        stop_timer.cancel()
        stop_timer = None
    remaining_time_label.config(text="녹화 종료 및 업로드 중...")

def capture_loop(region):
    with mss.mss() as sct:
        while recording:
            try:
                rect = get_window_rect()
                if rect:
                    monitor = {"top": rect["top"], "left": rect["left"], "width": rect["width"], "height": rect["height"]}
                    img = np.array(sct.grab(monitor))
                    frame = cv2.cvtColor(img, cv2.COLOR_BGRA2BGR)
                    if frame.shape[1] != region["width"] or frame.shape[0] != region["height"]:
                        frame = cv2.resize(frame, (region["width"], region["height"]))
                    video_writer.write(frame)
            except: pass
            time.sleep(CAPTURE_INTERVAL)

# ------- [6. 예약 및 파일 관리] --------
def add_schedule(day, time_str, listbox):
    if not time_str or ":" not in time_str: return
    schedules.append((day, time_str))
    schedules.sort(key=lambda x: (["Mon","Tue","Wed","Thu","Fri","Sat","Sun"].index(x[0]), int(x[1].split(":")[0])*60 + int(x[1].split(":")[1])))
    listbox.delete(0, tk.END)
    for d, t in schedules: listbox.insert(tk.END, f"{d} {t}")
    save_schedules()

def remove_schedule(listbox):
    sel = listbox.curselection()
    if not sel: return
    schedules.pop(sel[0])
    listbox.delete(sel[0])
    save_schedules()

def schedule_checker():
    while True:
        now = datetime.now()
        if any(d == now.strftime("%a") and t == now.strftime("%H:%M") for d, t in schedules) and not recording:
            start_recording()
        time.sleep(30)

def save_schedules():
    with open(SCHEDULE_FILE, "w", newline="", encoding="utf-8") as f:
        csv.writer(f).writerows(schedules)

def load_schedules(listbox):
    if os.path.exists(SCHEDULE_FILE):
        with open(SCHEDULE_FILE, "r", encoding="utf-8") as f:
            for row in csv.reader(f):
                if len(row) == 2:
                    schedules.append((row[0], row[1]))
                    listbox.insert(tk.END, f"{row[0]} {row[1]}")

# ------- [7. GUI 및 종료 처리] --------
def on_closing():
    if recording:
        if messagebox.askokcancel("종료", "녹화 중입니다. 정지 후 업로드하고 종료할까요?"):
            stop_recording()
            root.after(1000, root.destroy)
    else: root.destroy()

def gui_app():
    global root, auto_stop_enabled, remaining_time_label
    root = tk.Tk()
    root.title("클라우드스쿨 녹화 도구")
    root.protocol("WM_DELETE_WINDOW", on_closing)

    tk.Button(root, text="녹화 시작", command=start_recording, width=20).pack(pady=5)
    tk.Button(root, text="녹화 정지", command=stop_recording, width=20).pack(pady=5)
    
    auto_stop_enabled = tk.BooleanVar(value=True)
    tk.Checkbutton(root, text="자동 종료 (45분)", variable=auto_stop_enabled).pack()
    remaining_time_label = tk.Label(root, text="대기 중...")
    remaining_time_label.pack()

    frame = tk.LabelFrame(root, text="예약 관리")
    frame.pack(pady=10, fill="both", expand=True)

    day_var = tk.StringVar(value="Mon")
    day_frame = tk.Frame(frame)
    day_frame.pack()
    for d in ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]:
        tk.Radiobutton(day_frame, text=d, value=d, variable=day_var).pack(side="left")

    time_entry = tk.Entry(frame)
    time_entry.pack()
    
    list_frame = tk.Frame(frame)
    list_frame.pack(fill="both", expand=True)
    listbox = tk.Listbox(list_frame, height=10)
    listbox.pack(side="left", fill="both", expand=True)
    
    tk.Button(frame, text="추가", command=lambda: add_schedule(day_var.get(), time_entry.get(), listbox)).pack(side="left")
    tk.Button(frame, text="삭제", command=lambda: remove_schedule(listbox)).pack(side="left")

    load_schedules(listbox)
    threading.Thread(target=schedule_checker, daemon=True).start()
    root.mainloop()

if __name__ == "__main__":
    gui_app()
