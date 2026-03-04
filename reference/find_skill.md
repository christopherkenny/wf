# Search for skills on GitHub

Searches GitHub for repositories tagged with the `claude-skill` topic,
optionally filtered by a keyword query.

## Usage

``` r
find_skill(query = NULL)
```

## Arguments

- query:

  Optional keyword to narrow the search. If `NULL`, all repositories
  with the `claude-skill` topic are returned.

## Value

A data frame with columns:

- `name`: repository name.

- `description`: repository description.

- `owner`: repository owner login.

- `url`: full URL of the repository.

- `stars`: number of GitHub stars.

## Examples

``` r
# \donttest{
find_skill()
#>                                name
#> 1                       ClaudeForge
#> 2             claude-code-aso-skill
#> 3                             skyll
#> 4                     claude-skills
#> 5              google-ai-mode-skill
#> 6                Apple-Hig-Designer
#> 7              claude-code-settings
#> 8              claude-android-skill
#> 9    wechat-article-publisher-skill
#> 10                           Textum
#> 11   wechat-article-formatter-skill
#> 12        claude-code-design-skills
#> 13                     claude-coach
#> 14                 gtd-coach-plugin
#> 15                        spec-flow
#> 16            blockrun-agent-wallet
#> 17                        codex-kkp
#> 18                Agentic-SEO-Skill
#> 19              claude-skill-reddit
#> 20    claude-skill-prompt-architect
#> 21            claude-code-aso-skill
#> 22          creative-director-skill
#> 23          dataforseo-skill-claude
#> 24              EdgeKnowledge_Skill
#> 25 linkedin-article-publisher-skill
#> 26           claude-ai-music-skills
#> 27                 product-spec-kit
#> 28               odin-claude-plugin
#> 29                   fastlane-skill
#> 30                   crawl4ai-skill
#>                                                                                                                                                                                                                                                                                                                                            description
#> 1                                                                                                                                                                         A CLAUDE.md Generator and Maintenance tool for for Claude Code to create high-quality CLAUDE.md instruction files — aligned with Anthropic’s best practices for Claude Code.
#> 2  AEO Automation Framework for Claude Code One-click, beginner friendly automation for GitHub. Includes a dedicated fleet of AEO sub-agents handling planning, execution, reports, actionable items, and executive summaries. Trigger work instantly with AEO slash-commands. Fully integrated as a Claude Code Skill and usable across Claude AI App
#> 3                                                                                                                                                                                                                                                                                       A tool for AI agents to discover and learn skills autonomously
#> 4                                                                                                                                                                                                                                                                                                                       My collection of Claude skills
#> 5                                                                                                                                                                                    Claude Code skill for free Google AI Mode search with citations. Zero-config setup, persistent browser profile, query optimization. Token-efficient web research.
#> 6                                                                                                                                                                                                                                                 A Claude Code Skill for designing professional interfaces following Apple Human Interface Guidelines
#> 7                                                                                                                                                                                                                                                                                                         Best Practices for Claude Code Configuration
#> 8                                                                                                                                                                                                                                                                         Claude Code skill for building modern Android apps following best practices.
#> 9                                                                                                                                                                                                                                                                                       Claude Skill that publish on Wechat articles (微信公众号发布）
#> 10                                                                                                                                                          Structured workflow that stops AI from forgetting your requirements. 4 phases with validation gates. Not smarter AI, just controllable process. Weave ideas into code that actually works.
#> 11                                                                                                                                                                                                                                                        Claude Skill that format Wechat articles for 微信公众号 (微信公众号文章排版，支持自定义样式)
#> 12                                                                                                                                                                                                                                                                                         Claude Code skills for automated design-to-code workflows. 
#> 13                                                                                                                                                                                                                                                                  Claude as your endurance coach for marathons, triathlons, Ironman events, and more
#> 14                                                                                                                                                                                                                                                       Claude Skill that break down everyday's todo with details action plan based on your goal/plan
#> 15                                                                                                                                                                                                                                   A Claude Code skill for structured, spec-driven development with phase-by-phase workflow and living documentation
#> 16                                                                                                                                                                                                                   Give AI agents a wallet to pay for GPT, Grok, DALL-E, and 30+ models. No API keys needed. Works with Claude Code and Antigravity.
#> 17                                                                                                                                                                                                              A Claude Code Plugin that enables seamless integration with Codex AI Agent for code analysis, implementation, and collaboration tasks.
#> 18                                                                                                                                                                       An LLM-first SEO analysis skill for Antigravity, Codex, Claude with 12 specialized sub-skills, 6 specialist agents, and optional utility scripts used as evidence collectors.
#> 19                                                                                                                                                                                                                Claude Code skills for Reddit automation (AppleScript + Chrome). Build karma, post to subreddits — undetectable by anti-bot systems.
#> 20                                                                                                                                                                           Claude Code skill that transforms vague prompts into structured, expert-level prompts using 7 research-backed   frameworks (CO-STAR, RISEN, RISE, TIDD-EC, RTF, CoT, CoD)
#> 21                                                                                                                                                                                                                                   🚀 Optimize App Store visibility with AI agents in the Claude Code framework for enhanced performance and growth.
#> 22                                                                                                                                          AI Creative Director skill for Claude, GPT, Gemini — 20+ methodologies (SIT, TRIZ, Bisociation, SCAMPER), Cannes-calibrated scoring, recursive refinement. Insight → Ideation → Evaluation → Presentation.
#> 23                                                                                                                                                                                                                                                                                DataForSEO API skill for Claude Code - Complete SEO data integration
#> 24                                                                                                                                                                     AI-powered edge knowledge mining from underground forums. Deep crawls Reddit, BlackHatWorld,   GreyHatMafia with browser automation, visual analysis, and structured reporting.
#> 25                                                                                                                                                                                                                                                                                                       Claude Skill that publish on LinkedIn article
#> 26                                                                                                                                                                                                                                                                        Human + AI music production workflow for Suno - skills, templates, and tools
#> 27                                                                                                                                                                                                                                          Leverage AI to create, refine, and maintain your product specifications. Made to be used in LLMs and IDEs.
#> 28                                                                                                                                                                                                                                                   ODIN [for Claude Code as a plugin] - Outline Driven development approach for agentic INtelligence
#> 29                                                                                                                                                                                                                                                     AI skill to setup and use fastlane to automate building and releasing your iOS and Android apps
#> 30                                                                                                                                    Web scraping skill for Claude AI. Crawl websites, extract structured data with CSS/LLM strategies, handle dynamic JavaScript content. Built on crawl4ai with complete SDK reference, example scripts, and tests.
#>                   owner
#> 1        alirezarezvani
#> 2        alirezarezvani
#> 3           assafelovic
#> 4            oaustegard
#> 5         PleasePrompto
#> 6              axiaoge2
#> 7          nokonoko1203
#> 8               dpconde
#> 9              iamzifei
#> 10            snakeying
#> 11             iamzifei
#> 12            scoobynko
#> 13       felixrieseberg
#> 14             iamzifei
#> 15              echoVic
#> 16           BlockRunAI
#> 17         ForteScarlet
#> 18        Bhanunamikaze
#> 19               PHY041
#> 20              ckelsoe
#> 21               wsbs20
#> 22                smixs
#> 23       nikhilbhansali
#> 24         1596941391qq
#> 25             iamzifei
#> 26 bitwize-music-studio
#> 27             diegoeis
#> 28        OutlineDriven
#> 29       greenstevester
#> 30          brettdavies
#>                                                               url stars
#> 1                   https://github.com/alirezarezvani/ClaudeForge   289
#> 2         https://github.com/alirezarezvani/claude-code-aso-skill   232
#> 3                            https://github.com/assafelovic/skyll   215
#> 4                     https://github.com/oaustegard/claude-skills   108
#> 5           https://github.com/PleasePrompto/google-ai-mode-skill   107
#> 6                  https://github.com/axiaoge2/Apple-Hig-Designer    96
#> 7            https://github.com/nokonoko1203/claude-code-settings    90
#> 8                 https://github.com/dpconde/claude-android-skill    64
#> 9      https://github.com/iamzifei/wechat-article-publisher-skill    63
#> 10                            https://github.com/snakeying/Textum    41
#> 11     https://github.com/iamzifei/wechat-article-formatter-skill    38
#> 12         https://github.com/scoobynko/claude-code-design-skills    31
#> 13                 https://github.com/felixrieseberg/claude-coach    28
#> 14                   https://github.com/iamzifei/gtd-coach-plugin    27
#> 15                           https://github.com/echoVic/spec-flow    26
#> 16            https://github.com/BlockRunAI/blockrun-agent-wallet    23
#> 17                      https://github.com/ForteScarlet/codex-kkp    23
#> 18             https://github.com/Bhanunamikaze/Agentic-SEO-Skill    21
#> 19                  https://github.com/PHY041/claude-skill-reddit    20
#> 20       https://github.com/ckelsoe/claude-skill-prompt-architect    20
#> 21                https://github.com/wsbs20/claude-code-aso-skill    20
#> 22               https://github.com/smixs/creative-director-skill    19
#> 23      https://github.com/nikhilbhansali/dataforseo-skill-claude    19
#> 24            https://github.com/1596941391qq/EdgeKnowledge_Skill    15
#> 25   https://github.com/iamzifei/linkedin-article-publisher-skill    13
#> 26 https://github.com/bitwize-music-studio/claude-ai-music-skills    12
#> 27                   https://github.com/diegoeis/product-spec-kit    12
#> 28            https://github.com/OutlineDriven/odin-claude-plugin    11
#> 29               https://github.com/greenstevester/fastlane-skill    10
#> 30                  https://github.com/brettdavies/crawl4ai-skill     9
find_skill('typescript')
#>                    name
#> 1  bluesky_claude_skill
#> 2    Next-Unicorn-Skill
#> 3 prompt-engineer-skill
#>                                                                                                                                                     description
#> 1                                        Manual-only Claude Code Skill for Bluesky using @atproto/api with dry-run, backoff, and destructive-action guardrails.
#> 2 AI-powered codebase auditor that detects reinvented wheels and suggests unicorn-grade library replacements. Stop Vibe Coding debt with smart migration plans.
#> 3                           🚀 Transform rough ideas into production-ready prompts for multiple LLMs with advanced techniques and model-specific optimizations.
#>             owner                                                     url stars
#> 1 BeMoreDifferent https://github.com/BeMoreDifferent/bluesky_claude_skill     0
#> 2         Nebutra           https://github.com/Nebutra/Next-Unicorn-Skill     1
#> 3    pateljig4545   https://github.com/pateljig4545/prompt-engineer-skill     0
# }
```
