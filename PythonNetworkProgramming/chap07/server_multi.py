import sys, time, launcelot
from multiprocessing import Process
from server import server_loop
from threading import Thread

WORKER_CLASSES = {'thread':Thread, 'process':Process}
WORKER_MAX = 3

def start_worker(Worker, listen_sock):
    worker = Worker(target = server_loop, args = (listen_sock,))
    worker.daemon = True
    worker.start()
    return worker

if __name__ == '__main__':
    if len(sys.argv) != 3 and sys.argv[2] not in WORKER_CLASSES:
        print('usage: server_multi.py interface thread|process', file = sys.stderr)
        sys.exit(2)
    listen_sock = launcelot.setup()
    Worker = WORKER_CLASSES[sys.argv.pop()]
    workers = []
    for i in range(WORKER_MAX):
        workers.append(start_worker(Worker, listen_sock))
    while True:
        time.sleep(2)
        for worker in workers:
            if not worker.is_alive():
                print(worker.name, "died; starting replacement")
                workers.remove(worker)
                workers.append(start_worker(Worker, listen_sock))
