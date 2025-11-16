from fastapi import FastAPI, UploadFile, File
from fastapi.responses import StreamingResponse
from moviepy.editor import ImageSequenceClip, AudioFileClip
import tempfile
import shutil
import os

app = FastAPI()

@app.post("/create-video")
async def create_video(
    images: list[UploadFile] = File(...),
    audio: UploadFile | None = File(None)
):
    # temp directory for everything
    temp_dir = tempfile.mkdtemp()
    image_paths = []

    # 1) Save uploaded images in order
    for index, file in enumerate(images):
        ext = os.path.splitext(file.filename)[1]
        image_path = os.path.join(temp_dir, f"{index}{ext}")
        with open(image_path, "wb") as f:
            shutil.copyfileobj(file.file, f)
        image_paths.append(image_path)

    # 2) Build video clip from images
    clip = ImageSequenceClip(image_paths, fps=30)

    # 3) If an audio file was provided, attach it
    if audio is not None:
        audio_path = os.path.join(temp_dir, "audio.mp3")
        with open(audio_path, "wb") as f:
            shutil.copyfileobj(audio.file, f)

        audio_clip = AudioFileClip(audio_path)

        # Option A: trim video to audio length
        duration = min(clip.duration, audio_clip.duration)
        clip = clip.set_duration(duration).set_audio(audio_clip)

        # Option B (if you want video to ignore audio length):
        # clip = clip.set_audio(audio_clip)

    # 4) Export final video
    output_path = os.path.join(temp_dir, "video.mp4")
    clip.write_videofile(output_path, codec="libx264", audio=audio is not None)

    # 5) Return video
    return StreamingResponse(
        open(output_path, "rb"),
        media_type="video/mp4",
        headers={"Content-Disposition": "attachment; filename=video.mp4"}
    )
