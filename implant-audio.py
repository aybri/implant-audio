#!/usr/bin/env python

import pyaudio

from aiohttp import web

app = web.Application()
routes = web.RouteTableDef()

@routes.get("/")
async def websocket_handler(request):
    ws = web.WebSocketResponse()
    await ws.prepare(request)

    p = pyaudio.PyAudio()  # Create an interface to PortAudio

    print('Recording')

    stream = p.open(format=pyaudio.paInt16,
                channels=2,
                rate=48000,
                frames_per_buffer=1024,
                input=True)

    print("Sending audio data...")
    while True:
        try:
            await ws.send_bytes(stream.read(1024))
        except ConnectionResetError:
            print("Disconnected!")

            # Stop and close the stream 
            stream.stop_stream()
            stream.close()
            # Terminate the PortAudio interface
            p.terminate()
            break
        except Exception as err:
            print(f"Unexpected {err=}, {type(err)=}")

            # Stop and close the stream 
            stream.stop_stream()
            stream.close()
            # Terminate the PortAudio interface
            p.terminate()
            break

app.add_routes(routes)
web.run_app(app)