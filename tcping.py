import argparse
import socket
import statistics
import time


def parse_args():
    parser = argparse.ArgumentParser(description="Simple TCP ping tool")
    parser.add_argument("host")
    parser.add_argument("port", type=int)
    parser.add_argument("-c", "--count", type=int, default=4)
    parser.add_argument("-t", "--timeout", type=int, default=1000)
    parser.add_argument("-i", "--interval", type=int, default=1000)
    return parser.parse_args()


def tcp_ping_once(host, port, timeout_ms):
    start = time.perf_counter()
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.settimeout(timeout_ms / 1000)
    try:
        sock.connect((host, port))
    finally:
        sock.close()
    elapsed_ms = (time.perf_counter() - start) * 1000
    return elapsed_ms


def main():
    args = parse_args()
    count = max(1, args.count)
    timeout_ms = max(1, args.timeout)
    interval_ms = max(0, args.interval)

    print(f"TCPing {args.host}:{args.port} with {count} attempts")

    times = []
    failed = 0

    for idx in range(1, count + 1):
        try:
            elapsed_ms = tcp_ping_once(args.host, args.port, timeout_ms)
            times.append(elapsed_ms)
            print(f"Reply from {args.host}:{args.port} time={elapsed_ms:.2f} ms")
        except Exception as exc:
            failed += 1
            message = str(exc) or exc.__class__.__name__
            print(f"Attempt {idx}: failed ({message})")

        if idx != count and interval_ms > 0:
            time.sleep(interval_ms / 1000)

    print("")
    print("Statistics")
    print(f"  Attempts: {count}")
    print(f"  Success: {len(times)}")
    print(f"  Failed: {failed}")

    if times:
        print(f"  Min: {min(times):.2f} ms")
        print(f"  Avg: {statistics.mean(times):.2f} ms")
        print(f"  Max: {max(times):.2f} ms")


if __name__ == "__main__":
    main()
