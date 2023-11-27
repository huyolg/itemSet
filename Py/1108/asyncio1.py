
import asyncio
import threading


async def async_fuc():
    print('%s thread' % threading.currentThread())

    await asyncio.sleep(2)

    print('%s ended' % threading.currentThread())


loop = asyncio.get_event_loop()
tasks = [async_fuc(), async_fuc()]
loop.run_until_complete(asyncio.wait(tasks))
asyncio.run(async_fuc())
print('waiting for sleep')
loop.close()
