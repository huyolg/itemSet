
import asyncio
import threading


async def saySomting():
    print('hello')
    await asyncio.sleep(1)
    print('baybay')

loop = asyncio.get_event_loop()
tasks = [saySomting(), saySomting()]
loop.run_until_complete(asyncio.wait(tasks))
print('over')
loop.close()
