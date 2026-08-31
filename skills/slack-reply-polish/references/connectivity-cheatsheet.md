# Connectivity Cheatsheet

返信に「動作確認方法お願いします」 等を含める時、 受信者環境を仮定せず **OS 別に並列提示** するための対応表。

## TCP 任意 port (= 例: 3000) への疎通

| OS | コマンド例 |
|---|---|
| **Mac** | `nc -vz host port` (= BSD netcat、 標準搭載) |
| **Linux** | `nc -vz host port` (= 大半の distro で標準) |
| **Windows PowerShell** | `Test-NetConnection -ComputerName host -Port port` |
| **Windows (= nc 不在多)** | nc は標準で入っていない、 PowerShell or 下記 HTTP 系で代替 |

## HTTP / HTTPS service への疎通

| OS / tool | コマンド例 |
|---|---|
| **ブラウザ (= 全 OS)** | `http://host:port/` or `https://host/` を開く (= 80/443 + HTTP service なら最速確認) |
| **curl (= Mac 10.13+ / Linux / Windows 10+)** | `curl -v http://host:port/` |
| **Windows PowerShell** | `Invoke-WebRequest -Uri http://host:port/` |

## OS 別の標準搭載状況

| tool | Mac | Linux | Windows |
|---|---|---|---|
| nc (netcat) | ✓ 標準 | ✓ 大半 | × 標準なし (= Cygwin / WSL / nmap-bundled 等で要 install) |
| curl | ✓ 10.13+ | ✓ ほぼ全 distro | ✓ 10+ 標準 |
| telnet | △ 10.13 で削除 | △ minimal install 次第 | × 標準なし、 install option |
| PowerShell `Test-NetConnection` | × | × | ✓ Windows 8+ 標準 |
| ブラウザ | ✓ | ✓ | ✓ |

## ICMP ping への疎通 (= 参考)

| OS | コマンド例 |
|---|---|
| Mac / Linux | `ping -c 4 host` |
| Windows | `ping host` (= default 4 回) |

## 返信文での提示例

複数 OS を並列で提示する例:

```
お手数ですが、 該当ネットワークから疎通確認をお願いいたします:
- ブラウザ: http://host:3000/
- curl: curl -v http://host:3000/
- Mac/Linux: nc -vz host 3000
- Windows PowerShell: Test-NetConnection -ComputerName host -Port 3000
```

= 受信者環境 (= Mac / Linux / Windows) を仮定せず網羅、 ブラウザ option は HTTP service 確実な場合に最も general。

## Service が HTTP か不明な時

`nc -vz` (TCP layer) + ブラウザ (HTTP layer) を併記すれば、 service が TCP non-HTTP でも TCP layer 疎通確認可能。

## Anti-patterns

- 「nc 使ってください」 等の single tool 限定指定 (= Windows 受信者に NG)
- 「telnet で」 (= Windows 不在 + Mac 10.13+ 削除済、 obsolete 寄り)
- port 番号忘れ (= `nc host` で port 抜けは無効)
- 「http://...」 と書きつつ実際は `https://` が必要 (= 443 開放後は https://、 80 開放時のみ http://)
