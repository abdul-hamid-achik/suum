class VideoUploader < Shrine
  plugin :derivatives

  Attacher.derivatives do |original|
    transcoded = Tempfile.new ['transcoded', '.mp4']
    screenshot = Tempfile.new ['screenshot', '.jpg']

    movie = FFMPEG::Movie.new(original.path)
    movie.transcode(transcoded.path)
    movie.screenshot(screenshot.path)

    { transcoded: transcoded, screenshot: screenshot }
  end
end
