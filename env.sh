#!/usr/bin/env bash

export LC_ALL=C

# Check bash version for associative arrays
if (( BASH_VERSINFO[0] < 4 )); then
    echo "Error: This script requires Bash 4.0 or newer for associative arrays."
    echo "On macOS, install newer bash: brew install bash"
    echo "Then run: /opt/homebrew/bin/bash env.sh"
    exit 1
fi

if [[ "$(uname)" == "Darwin" ]]; then
  function colorecho() {
    printf "%b%s%b\n" "$1" "$2" "\033[0m"
  }
else
  function colorecho() {
    echo -e "$1$2\033[0m"
  }
fi

# Generate secure password function
generate_password() {
  tr -dc 'A-Za-z0-9' </dev/urandom | head -c 32
  echo
}

# Generate JWT secret
generate_jwt_secret() {
  openssl rand -hex 64
}

# Logo
printf "\033[1;36m"
cat << "EOF"
 *   *  **  **  *   *
| | | | \ \/ / | | | |
| | | |  \  /  | | | |
| |_| |  /  \  | |_| |
 \___/  /_/\_\  \___/
EOF
printf "\033[0m"

colorecho "\033[1;32m" "🚀 Interaktywny Konfigurator Postiz"
colorecho "\033[1;33m" "===================================="
printf "\n"
colorecho "\033[1;36m📋 INSTRUKCJA:\033[0m"
colorecho "  \033[1;32m↵ ENTER\033[0m = Akceptuj wartość i przejdź dalej | \033[1;33m○ Puste pole\033[0m = Użyj wartości domyślnej"
colorecho "  \033[1;35m◐ Opcjonalne\033[0m = Można pominąć | \033[1;34mℹ️  Postęp\033[0m = [aktualne/całkowite] pytanie"
printf "\n"

# Configuration arrays
declare -a config_keys
declare -A config_values
declare -A config_descriptions
declare -A config_defaults

# All configuration keys in order
config_keys=(
    "domain" "use_https" "frontend_port" "backend_port" "disable_registration" "disable_image_compression" "storage_provider"
    "cloudflare_account_id" "cloudflare_access_key" "cloudflare_secret_access_key" "cloudflare_bucketname" "cloudflare_bucket_url" "cloudflare_region"
    "resend_api_key" "email_from_address" "email_from_name"
    "openai_api_key"
    "x_api_key" "x_api_secret"
    "linkedin_client_id" "linkedin_client_secret"
    "facebook_app_id" "facebook_app_secret"
    "threads_app_id" "threads_app_secret"
    "youtube_client_id" "youtube_client_secret"
    "tiktok_client_id" "tiktok_client_secret"
    "pinterest_client_id" "pinterest_client_secret"
    "reddit_client_id" "reddit_client_secret"
    "github_client_id" "github_client_secret"
    "dribbble_client_id" "dribbble_client_secret"
    "discord_client_id" "discord_client_secret" "discord_bot_token_id"
    "slack_id" "slack_secret" "slack_signing_secret"
    "mastodon_url" "mastodon_client_id" "mastodon_client_secret"
    "beehiive_api_key" "beehiive_publication_id"
)

# Set descriptions with helpful info and links
config_descriptions["domain"]="Domena/URL aplikacji np. uxu.pl"
config_descriptions["use_https"]="Użyć HTTPS? (y/N)"
config_descriptions["frontend_port"]="Port frontendu"
config_descriptions["backend_port"]="Port backendu"
config_descriptions["disable_registration"]="Wyłączyć rejestrację nowych użytkowników? (y/N)"
config_descriptions["disable_image_compression"]="Wyłączyć kompresję obrazów? (y/N)"
config_descriptions["storage_provider"]="Provider przechowywania plików (local/cloudflare)"

config_descriptions["cloudflare_account_id"]="Cloudflare Account ID (z dash.cloudflare.com/r2)"
config_descriptions["cloudflare_access_key"]="Cloudflare Access Key (z R2 → Manage API tokens)"
config_descriptions["cloudflare_secret_access_key"]="Cloudflare Secret Access Key (z R2 → Manage API tokens)"
config_descriptions["cloudflare_bucketname"]="Cloudflare R2 Bucket Name (utworzony w R2 Console)"
config_descriptions["cloudflare_bucket_url"]="Cloudflare Bucket URL (custom domain lub domyślny)"
config_descriptions["cloudflare_region"]="Cloudflare Region (np. wnam, enam)"

config_descriptions["resend_api_key"]="Resend API Key (z resend.com → API Keys)"
config_descriptions["email_from_address"]="Email nadawcy (zweryfikowany w Resend)"
config_descriptions["email_from_name"]="Nazwa nadawcy (np. Twoja Firma)"

config_descriptions["openai_api_key"]="OpenAI API Key (do generowania treści AI z platform.openai.com → API keys)"

config_descriptions["x_api_key"]="X (Twitter) API Key (z developer.twitter.com → Apps)"
config_descriptions["x_api_secret"]="X (Twitter) API Secret (z developer.twitter.com → Apps)"

config_descriptions["linkedin_client_id"]="LinkedIn Client ID (z linkedin.com/developers → Apps)"
config_descriptions["linkedin_client_secret"]="LinkedIn Client Secret (z linkedin.com/developers → Apps)"

config_descriptions["facebook_app_id"]="Facebook App ID (z developers.facebook.com → Apps)"
config_descriptions["facebook_app_secret"]="Facebook App Secret (z developers.facebook.com → Apps)"

config_descriptions["threads_app_id"]="Threads App ID (z developers.facebook.com → Apps)"
config_descriptions["threads_app_secret"]="Threads App Secret (z developers.facebook.com → Apps)"

config_descriptions["youtube_client_id"]="YouTube Client ID (z console.cloud.google.com → APIs)"
config_descriptions["youtube_client_secret"]="YouTube Client Secret (z console.cloud.google.com → APIs)"

config_descriptions["tiktok_client_id"]="TikTok Client ID (z developers.tiktok.com → Apps)"
config_descriptions["tiktok_client_secret"]="TikTok Client Secret (z developers.tiktok.com → Apps)"

config_descriptions["pinterest_client_id"]="Pinterest Client ID (z developers.pinterest.com → Apps)"
config_descriptions["pinterest_client_secret"]="Pinterest Client Secret (z developers.pinterest.com → Apps)"

config_descriptions["reddit_client_id"]="Reddit Client ID (z reddit.com/prefs/apps)"
config_descriptions["reddit_client_secret"]="Reddit Client Secret (z reddit.com/prefs/apps)"

config_descriptions["github_client_id"]="GitHub Client ID (z github.com/settings/developers → OAuth Apps)"
config_descriptions["github_client_secret"]="GitHub Client Secret (z github.com/settings/developers → OAuth Apps)"

config_descriptions["dribbble_client_id"]="Dribbble Client ID (z dribbble.com/account/applications)"
config_descriptions["dribbble_client_secret"]="Dribbble Client Secret (z dribbble.com/account/applications)"

config_descriptions["discord_client_id"]="Discord Client ID (z discord.com/developers/applications)"
config_descriptions["discord_client_secret"]="Discord Client Secret (z discord.com/developers/applications)"
config_descriptions["discord_bot_token_id"]="Discord Bot Token (z discord.com/developers/applications → Bot)"

config_descriptions["slack_id"]="Slack App ID (z api.slack.com/apps)"
config_descriptions["slack_secret"]="Slack App Secret (z api.slack.com/apps → Basic Information)"
config_descriptions["slack_signing_secret"]="Slack Signing Secret (z api.slack.com/apps → Basic Information)"

config_descriptions["mastodon_url"]="Mastodon Instance URL (np. mastodon.social)"
config_descriptions["mastodon_client_id"]="Mastodon Client ID (z twojej instancji → Development)"
config_descriptions["mastodon_client_secret"]="Mastodon Client Secret (z twojej instancji → Development)"

config_descriptions["beehiive_api_key"]="Beehiiv API Key (z beehiiv.com → Settings → Integrations)"
config_descriptions["beehiive_publication_id"]="Beehiiv Publication ID (z beehiiv.com → Settings → Integrations)"

# Set defaults
config_defaults["domain"]="localhost"
config_defaults["use_https"]="N"
config_defaults["frontend_port"]="4200"
config_defaults["backend_port"]="3000"
config_defaults["disable_registration"]="N"
config_defaults["storage_provider"]="local"
config_defaults["cloudflare_region"]="auto"
config_defaults["email_from_name"]="UXU"
config_defaults["mastodon_url"]="https://mastodon.social"

# Show statistics
colorecho "\033[1;34m📊 Statystyki:\033[0m" "Łącznie pytań: ${#config_keys[@]} | Social Media: 26 platform | Opcjonalne: większość"
printf "\n"

# Function to ask for value (simplified, no navigation)
ask_for_value() {
    local key="$1"
    local description="${config_descriptions[$key]}"
    local default="${config_defaults[$key]}"

    # Enhanced prompt with better formatting
    if [[ -n "$default" ]]; then
        printf "  \033[1;36m❓ %s\033[0m \033[1;33m[%s]\033[0m: " "$description" "$default"
    else
        printf "  \033[1;36m❓ %s\033[0m \033[1;35m[opcjonalne]\033[0m: " "$description"
    fi

    # Show documentation link for social media
    case "$key" in
        "linkedin_"*)
            printf "\n  \033[1;34m📖 Docs: https://docs.postiz.com/providers/linkedin\033[0m\n  \033[1;32m↳\033[0m " ;;
        "facebook_"*)
            printf "\n  \033[1;34m📖 Docs: https://docs.postiz.com/providers/facebook\033[0m\n  \033[1;32m↳\033[0m " ;;
        "discord_"*)
            printf "\n  \033[1;34m📖 Docs: https://docs.postiz.com/providers/discord\033[0m\n  \033[1;32m↳\033[0m " ;;
        "dribbble_"*)
            printf "\n  \033[1;34m📖 Docs: https://docs.postiz.com/providers/dribbble\033[0m\n  \033[1;32m↳\033[0m " ;;
        "youtube_"*)
            printf "\n  \033[1;34m📖 Docs: https://docs.postiz.com/providers/youtube\033[0m\n  \033[1;32m↳\033[0m " ;;
        "reddit_"*)
            printf "\n  \033[1;34m📖 Docs: https://docs.postiz.com/providers/reddit\033[0m\n  \033[1;32m↳\033[0m " ;;
        "github_"*)
            printf "\n  \033[1;34m📖 Docs: https://docs.postiz.com/providers/github\033[0m\n  \033[1;32m↳\033[0m " ;;
        "x_"*)
            printf "\n  \033[1;34m📖 Docs: https://docs.postiz.com/providers/x\033[0m\n  \033[1;32m↳\033[0m " ;;
        "tiktok_"*)
            printf "\n  \033[1;34m📖 Docs: https://docs.postiz.com/providers/tiktok\033[0m\n  \033[1;32m↳\033[0m " ;;
        "threads_"*)
            printf "\n  \033[1;34m📖 Docs: https://docs.postiz.com/providers/threads\033[0m\n  \033[1;32m↳\033[0m " ;;
        "pinterest_"*)
            printf "\n  \033[1;34m📖 Docs: https://docs.postiz.com/providers/pinterest\033[0m\n  \033[1;32m↳\033[0m " ;;
        "mastodon_"*)
            printf "\n  \033[1;34m📖 Docs: https://docs.postiz.com/providers/mastodon\033[0m\n  \033[1;32m↳\033[0m " ;;
        "slack_"*)
            printf "\n  \033[1;34m📖 Docs: https://docs.postiz.com/providers/slack\033[0m\n  \033[1;32m↳\033[0m " ;;
    esac

    # Read input normally
    read -r input

    # If empty, use default value
    if [[ -z "$input" ]]; then
        config_values["$key"]="$default"
    else
        config_values["$key"]="$input"
    fi
}

# Main configuration loop (simplified with conditional logic)
current_index=0
total_keys=${#config_keys[@]}

for current_key in "${config_keys[@]}"; do
    ((current_index++))

    # Skip Cloudflare questions if storage_provider is "local"
    if [[ "$current_key" =~ ^cloudflare_ ]] && [[ "${config_values[storage_provider]}" == "local" ]]; then
        colorecho "\033[1;90m📊 [$current_index/$total_keys - $((current_index * 100 / total_keys))%] $current_key \033[1;33m[pomijane - używasz local storage]\033[0m"
        config_values["$current_key"]=""
        continue
    fi

    # Skip email questions if no resend_api_key and current key is email related (but not resend_api_key itself)
    if [[ "$current_key" =~ ^email_ ]] && [[ -z "${config_values[resend_api_key]}" ]] && [[ "$current_key" != "resend_api_key" ]]; then
        colorecho "\033[1;90m📊 [$current_index/$total_keys - $((current_index * 100 / total_keys))%] $current_key \033[1;33m[pomijane - brak Resend API]\033[0m"
        config_values["$current_key"]=""
        continue
    fi

    # Display progress with better formatting
    progress_percent=$((current_index * 100 / total_keys))
    colorecho "\033[1;34m📊 [$current_index/$total_keys - ${progress_percent}%]\033[0m \033[1;37m$current_key\033[0m"

    # Show category headers with better formatting
    case "$current_key" in
        "domain")
            colorecho "\033[1;35m📱 === PODSTAWOWA KONFIGURACJA APLIKACJI ===\033[0m"
            ;;
        "cloudflare_account_id")
            colorecho "\033[1;35m☁️  === CLOUDFLARE R2 STORAGE (opcjonalne) ===\033[0m"
            colorecho "\033[1;37m    Przechowywanie plików w chmurze (alternatywa dla local storage)\033[0m"
            printf "\n  \033[1;34m📖 Docs: https://docs.postiz.com/configuration/r2\033[0m\n"
            ;;
        "resend_api_key")
            colorecho "\033[1;35m📧 === KONFIGURACJA EMAIL (opcjonalne) ===\033[0m"
            colorecho "\033[1;37m    Wysyłanie emaili aktywacyjnych i powiadomień do użytkowników\033[0m"
            ;;
        "openai_api_key")
            colorecho "\033[1;35m🤖 === KONFIGURACJA AI (opcjonalne) ===\033[0m"
            colorecho "\033[1;37m    Generowanie treści postów za pomocą sztucznej inteligencji\033[0m"
            ;;
        "x_api_key")
            colorecho "\033[1;35m📱 === SOCIAL MEDIA APIs (opcjonalne) ===\033[0m"
            colorecho "\033[1;37m    Łączenie z platformami social media do automatycznego publikowania\033[0m"
            ;;
    esac

    # Ask for value
    ask_for_value "$current_key"

    printf "\n"
done

# Generate passwords automatically
DB_PASSWORD_POSTGRES=$(generate_password)
REDIS_PASSWORD=$(generate_password)
JWT_SECRET=$(generate_jwt_secret)

# Set URLs based on configuration
domain="${config_values[domain]}"
use_https="${config_values[use_https]}"
frontend_port="${config_values[frontend_port]}"
backend_port="${config_values[backend_port]}"

if [[ "$use_https" =~ ^[Yy]$ ]]; then
    protocol="https"
else
    protocol="http"
fi

FRONTEND_URL="$protocol://$domain:$frontend_port"
NEXT_PUBLIC_BACKEND_URL="$protocol://$domain:$backend_port"
BACKEND_INTERNAL_URL="http://localhost:3000"

DATABASE_URL="postgresql://postiz:${DB_PASSWORD_POSTGRES}@postiz_postgres:5432/postiz"
REDIS_URL="redis://default:${REDIS_PASSWORD}@postiz_redis:6379"

colorecho "\033[1;34m[INFO]\033[0m" "Generowanie pliku .env..."

# Convert disable_registration boolean value
disable_registration_value="false"
if [[ "${config_values[disable_registration]}" =~ ^[Yy]$ ]]; then
    disable_registration_value="true"
fi

disable_image_compression="false"
if [[ "${config_values[disable_image_compression]}" =~ ^[Yy]$ ]]; then
    disable_image_compression="true"
fi


# Generate .env file with English comments
cat > .env <<EOF
# ===========================================
# POSTIZ ENVIRONMENT CONFIGURATION
# Configuration reference: https://docs.postiz.com/configuration/reference
# Generated on: $(date)
# ===========================================

# ===========================================
# REQUIRED SETTINGS
# ===========================================

# Database URL - PostgreSQL connection string
DATABASE_URL=$DATABASE_URL

# Redis URL - Redis connection string for caching and queues
REDIS_URL=$REDIS_URL
REDIS_PASSWORD=$REDIS_PASSWORD

# JWT Secret - Random string for securing JWT tokens
JWT_SECRET=$JWT_SECRET

# Application URLs - Frontend and backend access URLs
FRONTEND_URL=$FRONTEND_URL
NEXT_PUBLIC_BACKEND_URL=$NEXT_PUBLIC_BACKEND_URL
BACKEND_INTERNAL_URL=$BACKEND_INTERNAL_URL

# ===========================================
# DOCKER COMPOSE CONFIGURATION
# ===========================================
DB_POSTGRES=postiz
DB_USER_POSTGRES=postiz
DB_PASSWORD_POSTGRES=$DB_PASSWORD_POSTGRES

FRONTEND_PORT=$frontend_port
BACKEND_PORT=$backend_port

# ===========================================
# OPTIONAL SETTINGS
# ===========================================
# File storage provider - 'local' or 'cloudflare'
STORAGE_PROVIDER=${config_values[storage_provider]}

# Disable new user registration after first user
DISABLE_REGISTRATION=$disable_registration_value

# Disable image compression
DISABLE_IMAGE_COMPRESSION=$disable_image_compression

# ===========================================
# CLOUDFLARE R2 STORAGE (OPTIONAL)
# ===========================================
# Cloudflare R2 credentials for file storage (S3-compatible, free tier available)
CLOUDFLARE_ACCOUNT_ID=${config_values[cloudflare_account_id]}
CLOUDFLARE_ACCESS_KEY=${config_values[cloudflare_access_key]}
CLOUDFLARE_SECRET_ACCESS_KEY=${config_values[cloudflare_secret_access_key]}
CLOUDFLARE_BUCKETNAME=${config_values[cloudflare_bucketname]}
CLOUDFLARE_BUCKET_URL=${config_values[cloudflare_bucket_url]}
CLOUDFLARE_REGION=${config_values[cloudflare_region]}

# ===========================================
# EMAIL CONFIGURATION (OPTIONAL)
# ===========================================
# Resend API for email delivery - if present, user activation is required
RESEND_API_KEY=${config_values[resend_api_key]}
EMAIL_FROM_ADDRESS=${config_values[email_from_address]}
EMAIL_FROM_NAME=${config_values[email_from_name]}

# ===========================================
# SOCIAL MEDIA API KEYS
# ===========================================

# X (Twitter) API credentials
X_API_KEY=${config_values[x_api_key]}
X_API_SECRET=${config_values[x_api_secret]}

# LinkedIn API credentials
LINKEDIN_CLIENT_ID=${config_values[linkedin_client_id]}
LINKEDIN_CLIENT_SECRET=${config_values[linkedin_client_secret]}

# Facebook & Threads API credentials
FACEBOOK_APP_ID=${config_values[facebook_app_id]}
FACEBOOK_APP_SECRET=${config_values[facebook_app_secret]}
THREADS_APP_ID=${config_values[threads_app_id]}
THREADS_APP_SECRET=${config_values[threads_app_secret]}

# YouTube API credentials
YOUTUBE_CLIENT_ID=${config_values[youtube_client_id]}
YOUTUBE_CLIENT_SECRET=${config_values[youtube_client_secret]}

# TikTok API credentials
TIKTOK_CLIENT_ID=${config_values[tiktok_client_id]}
TIKTOK_CLIENT_SECRET=${config_values[tiktok_client_secret]}

# Pinterest API credentials
PINTEREST_CLIENT_ID=${config_values[pinterest_client_id]}
PINTEREST_CLIENT_SECRET=${config_values[pinterest_client_secret]}

# Reddit API credentials
REDDIT_CLIENT_ID=${config_values[reddit_client_id]}
REDDIT_CLIENT_SECRET=${config_values[reddit_client_secret]}

# GitHub API credentials
GITHUB_CLIENT_ID=${config_values[github_client_id]}
GITHUB_CLIENT_SECRET=${config_values[github_client_secret]}

# Dribbble API credentials
DRIBBBLE_CLIENT_ID=${config_values[dribbble_client_id]}
DRIBBBLE_CLIENT_SECRET=${config_values[dribbble_client_secret]}

# Discord API credentials
DISCORD_CLIENT_ID=${config_values[discord_client_id]}
DISCORD_CLIENT_SECRET=${config_values[discord_client_secret]}
DISCORD_BOT_TOKEN_ID=${config_values[discord_bot_token_id]}

# Slack API credentials
SLACK_ID=${config_values[slack_id]}
SLACK_SECRET=${config_values[slack_secret]}
SLACK_SIGNING_SECRET=${config_values[slack_signing_secret]}

# Mastodon API credentials
MASTODON_URL=${config_values[mastodon_url]}
MASTODON_CLIENT_ID=${config_values[mastodon_client_id]}
MASTODON_CLIENT_SECRET=${config_values[mastodon_client_secret]}

# Beehiiv API credentials
BEEHIIVE_API_KEY=${config_values[beehiive_api_key]}
BEEHIIVE_PUBLICATION_ID=${config_values[beehiive_publication_id]}

# ===========================================
# AI CONFIGURATION
# ===========================================
# OpenAI API key for AI-powered features
OPENAI_API_KEY=${config_values[openai_api_key]}

# ===========================================
# OAUTH SETTINGS (OPTIONAL)
# ===========================================
# Generic OAuth provider configuration
NEXT_PUBLIC_POSTIZ_OAUTH_DISPLAY_NAME=
NEXT_PUBLIC_POSTIZ_OAUTH_LOGO_URL=
POSTIZ_GENERIC_OAUTH=false
POSTIZ_OAUTH_URL=
POSTIZ_OAUTH_AUTH_URL=
POSTIZ_OAUTH_TOKEN_URL=
POSTIZ_OAUTH_USERINFO_URL=
POSTIZ_OAUTH_CLIENT_ID=
POSTIZ_OAUTH_CLIENT_SECRET=
EOF

printf "\n"
colorecho "\033[1;32m[SUCCESS]\033[0m" "Plik .env został wygenerowany z pełną konfiguracją!"
colorecho "\033[1;34m[INFO]\033[0m" "Lokalizacja: $(pwd)/.env"

printf "\n"
colorecho "\033[1;31m[WAŻNE]\033[0m" "Hasła zostały wygenerowane automatycznie i zapisane w pliku .env"
colorecho "\033[1;33m⚠️  Ze względów bezpieczeństwa hasła nie są wyświetlane w terminalu\033[0m"
colorecho "\033[1;36m📁 Sprawdź plik .env aby zobaczyć wygenerowane hasła\033[0m"
printf "\n"

colorecho "\033[1;36m" "Konfiguracja aplikacji:"
colorecho "\033[1;37m" "Frontend URL: $FRONTEND_URL"
colorecho "\033[1;37m" "Backend URL: $NEXT_PUBLIC_BACKEND_URL"
printf "\n"

colorecho "\033[1;36m" "Następne kroki:"
colorecho "\033[1;37m" "1. Sprawdź plik .env i popraw ewentualne błędy"
colorecho "\033[1;37m" "2. Uruchom aplikację: docker-compose down -v && docker-compose up -d"
colorecho "\033[1;37m" "3. Dostęp do aplikacji: $FRONTEND_URL"
colorecho "\033[1;37m" "4. Skonfiguruj social media przez interfejs web"

printf "\n"
colorecho "\033[1;32m" "Konfiguracja Postiz zakończona pomyślnie!"
colorecho "\033[1;33m" "========================================="

printf "\n"
colorecho "\033[1;33m" "┌─────────────────────────────────────────────────────────┐"
colorecho "\033[1;33m" "│                                                         │"
colorecho "\033[1;33m│  \033[1;36m *   *  **  **  *   *                                  \033[1;33m│"
colorecho "\033[1;33m│  \033[1;36m| | | | \ \/ / | | | |                                 \033[1;33m│"
colorecho "\033[1;33m│  \033[1;36m| | | |  \  /  | | | |                                 \033[1;33m│"
colorecho "\033[1;33m│  \033[1;36m| |_| |  /  \  | |_| |                                 \033[1;33m│"
colorecho "\033[1;33m│  \033[1;36m \___/  /_/\_\  \___/                                  \033[1;33m│"
colorecho "\033[1;33m│                                                         │"
colorecho "\033[1;33m│  \033[1;34m[NASTĘPNY KROK]\033[1;33m Aby uruchomić Postiz, wykonaj:         │"
colorecho "\033[1;33m│  \033[1;32m docker-compose up -d\033[1;33m                                  │"
colorecho "\033[1;33m│                                                         │"
colorecho "\033[1;33m└─────────────────────────────────────────────────────────┘"
printf "\n"