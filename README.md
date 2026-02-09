# TCPing 使用說明

這是一個簡單的 TCP 連線測試工具，提供 Windows 與 Linux 版本。

## Windows 版本（PowerShell）

檔案：`tcping.ps1`

### 執行方式

```powershell
./tcping.ps1 -Host example.com -Port 443 -Count 4 -TimeoutMs 1000 -IntervalMs 1000
```

### 參數

- `-Host`：目標主機或 IP
- `-Port`：目標連接埠
- `-Count`：嘗試次數（預設 4）
- `-TimeoutMs`：連線逾時（毫秒，預設 1000）
- `-IntervalMs`：每次嘗試間隔（毫秒，預設 1000）

### 輸出範例

```
TCPing example.com:443 with 4 attempts
Reply from example.com:443 time=12.34 ms
Reply from example.com:443 time=11.80 ms
Attempt 3: failed (timeout)
Reply from example.com:443 time=10.95 ms

Statistics
  Attempts: 4
  Success: 3
  Failed: 1
  Min: 10.95 ms
  Avg: 11.70 ms
  Max: 12.34 ms
```

## Linux 版本（Python 3）

檔案：`tcping.py`

### 執行方式

```bash
python3 tcping.py example.com 443 -c 4 -t 1000 -i 1000
```

### 參數

- `host`：目標主機或 IP
- `port`：目標連接埠
- `-c, --count`：嘗試次數（預設 4）
- `-t, --timeout`：連線逾時（毫秒，預設 1000）
- `-i, --interval`：每次嘗試間隔（毫秒，預設 1000）

### 輸出範例

```
TCPing example.com:443 with 4 attempts
Reply from example.com:443 time=12.34 ms
Reply from example.com:443 time=11.80 ms
Attempt 3: failed (timed out)
Reply from example.com:443 time=10.95 ms

Statistics
  Attempts: 4
  Success: 3
  Failed: 1
  Min: 10.95 ms
  Avg: 11.70 ms
  Max: 12.34 ms
```

## 小提示

- 逾時或連線失敗會顯示對應的錯誤訊息
- 若要測試本機服務，可用 `localhost` 或 `127.0.0.1`
