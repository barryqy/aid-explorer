# AI Defense Explorer Lab Helper

Student helper repo for the DevNet learning lab that uses Cisco AI Defense Explorer with a public DevNet LLM target.

## What Is Here

- `aid_explorer_target.py` starts a small OpenAI-compatible wrapper on port `8080`
- `start_target.sh` starts the wrapper and prints the Explorer target details

The wrapper expects the DevNet lab image to provide `LLM_BASE_URL` and `LLM_API_KEY`.
The generated `target.log` file records chat-style `Prompt` and `Response` entries with timestamps.
If you also want to log the full upstream payload with the hidden system prompt, start the server with `AID_EXPLORER_LOG_UPSTREAM=1`.

## Quick Start

```bash
cd /home/developer/src
git clone https://github.com/barryqy/aid-explorer.git
cd aid-explorer
./start_target.sh
```

If you need the target values again later:

```bash
./start_target.sh --details
./start_target.sh --health
```
