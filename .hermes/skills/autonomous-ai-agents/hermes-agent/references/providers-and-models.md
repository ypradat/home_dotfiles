# Providers & Model Aliases

Set via `hermes model` (picker) or `hermes setup`. 35+ provider profiles ship as
plugins under `plugins/model-providers/`; user plugins of the same name override.
Full docs: https://hermes-agent.nousresearch.com/docs/integrations/providers

### Providers

| Provider | Auth | Key env var(s) |
|----------|------|----------------|
| openrouter | API key | `OPENROUTER_API_KEY` |
| anthropic | API key | `ANTHROPIC_API_KEY` (also `CLAUDE_CODE_OAUTH_TOKEN`) |
| nous | OAuth device code | `hermes auth add nous` (or `NOUS_API_KEY`) |
| openai-codex | OAuth | `hermes auth add openai-codex` |
| qwen-oauth | OAuth | `hermes auth add qwen-oauth` |
| minimax-oauth | OAuth | `hermes auth add minimax-oauth` |
| copilot | Token | `COPILOT_GITHUB_TOKEN` / `GH_TOKEN` (Copilot device flow — `gh auth login` tokens do NOT work) |
| copilot-acp | External CLI | Copilot CLI on PATH or `COPILOT_CLI_PATH` |
| gemini | API key | `GOOGLE_API_KEY` or `GEMINI_API_KEY` |
| xai | API key | `XAI_API_KEY` (SuperGrok OAuth also supported) |
| deepseek | API key | `DEEPSEEK_API_KEY` |
| zai (GLM) | API key | `GLM_API_KEY` / `ZAI_API_KEY` |
| minimax / minimax-cn | API key | `MINIMAX_API_KEY` / `MINIMAX_CN_API_KEY` |
| kimi-coding / -cn | API key | `KIMI_API_KEY` / `KIMI_CN_API_KEY` |
| alibaba (+coding-plan) | API key | `DASHSCOPE_API_KEY` / `ALIBABA_CODING_PLAN_API_KEY` |
| xiaomi | API key | `XIAOMI_API_KEY` |
| huggingface | Token | `HF_TOKEN` |
| fireworks / novita / nvidia / deepinfra / gmi / arcee / stepfun / upstage / kilocode / ai-gateway / opencode-zen / opencode-go / ollama-cloud | API key | `<NAME>_API_KEY` |
| bedrock / vertex / azure-foundry | Cloud SDK / key | AWS SDK creds / Vertex ADC / `AZURE_FOUNDRY_API_KEY` |
| custom | Config | `model.base_url` + `model.api_key` in config.yaml |

Multiple credentials per provider pool and rotate automatically (`hermes auth`).
Fallback chain when the primary fails: `hermes fallback add|remove|list`.

### Subscription (OAuth) providers — a consumer plan, no API key

Some providers authenticate against a *consumer subscription* instead of an API
key. Connect them with `hermes auth add <provider> --type oauth`; the pooled
credential lands in `~/.hermes/auth.json`. Verify with
`hermes auth status <provider>` (expect `logged in`). Providers in this class:
`nous`, `openai-codex`, `qwen-oauth`, `minimax-oauth`.

**ChatGPT (Plus/Pro) — the key case.** A ChatGPT subscription does NOT grant
OpenAI API access (platform.openai.com keys bill separately). The subscription
path is the **`openai-codex`** provider (Codex OAuth, the same login as the
Codex CLI):

- `hermes auth add openai-codex --type oauth [--browser]`. Default is the
device-code flow; `--browser` uses the loopback PKCE flow on
`http://localhost:1455/auth/callback`. Either way the USER completes sign-in
in the browser — never type credentials yourself. The process prints the
authorize URL and waits for the callback (default 300s); run it in a background
PTY and poll the log for the URL, or let `--browser` open it.
- The Codex model catalog is **entitlement-gated and shifts**. Do NOT trust the
curated fallback list in `hermes_cli/codex_models.py` — it is forward-compat
synthetic and includes slugs the account may reject. A wrong slug returns
`HTTP 400: "...model is not supported when using Codex with a ChatGPT account"`;
public-API slugs like `gpt-5-codex` fail the same way.
- **Discover entitled slugs empirically** — one tiny call per candidate
(`OK` = available, HTTP 400 = not entitled):
  `hermes chat --provider openai-codex -m <slug> -q "say OK" --oneshot -Q`
- **Always name the provider.** `-m <codex-slug>` WITHOUT
`--provider openai-codex` falls through to the default provider and fails
("Model is unavailable"). Auto-routing never guesses a provider.

Make a subscription model one-command switchable with an alias, then use it on
every surface:

```
hermes config set model.aliases.chatgpt "openai-codex/<verified-slug>"
#   /model chatgpt            (this session)
#   /model chatgpt --global   (persist as default)
#   hermes chat -m chatgpt    (CLI / scripts)
```

### User-defined model aliases

Work with `/model <name>` in CLI and every gateway platform. Resolved by
`hermes_cli/model_switch.py::resolve_alias()`; user aliases are checked BEFORE
the built-in table, so a user `sonnet`/`grok` shadows the built-in.

```yaml
# Full form
model_aliases:
  fav:
    model: claude-sonnet-4.6
    provider: anthropic
  local-qwen:
    model: qwen3.5:397b
    provider: custom
    base_url: "https://ollama.com/v1"
  theta:
    model: theta-1
    provider: custom
    base_url: "https://theta.example.com/v1"
    key_env: THETA_API_KEY        # or: api_key: "${THETA_API_KEY}"

# Short form ("provider/model"), also via CLI:
#   hermes config set model.aliases.fav openrouter/anthropic/claude-sonnet-4.6
model:
  aliases:
    fav: openrouter/anthropic/claude-sonnet-4.6
```

`/model fav` — session-scoped; add `--global` to persist as default.

An alias with its own `base_url` authenticates with its own credential
(`api_key`, which also accepts a `"${VAR}"` reference, or `key_env`). With
neither set the key is resolved from the alias HOST, never carried over from
the provider that was active before the switch.

Built-in aliases (catalog-resolved against the active provider): `sonnet`,
`opus`, `haiku`, `claude`, `gpt5`, `gpt`, `codex`, `o3`, `o4`, `gemini`,
`deepseek`, `grok`, `llama`, `qwen`, `minimax`, `nemotron`, `kimi`, `glm`,
`step`, `mimo`, `trinity`.
