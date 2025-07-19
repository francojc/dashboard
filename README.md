# Universal Dashboard Web Service

A modern, responsive dashboard web service designed to display on any internet-connected device. Features a card-based design with weather, calendar, local information, and news feeds with automatic updates.

## Features

### Architecture & Performance

- **Universal Compatibility**: Runs on any device with a web browser
- **Server-Side Rendering**: Static HTML generation for optimal performance
- **Multi-Device Support**: Single dashboard service can serve multiple displays
- **Auto-Updates**: Refreshes data every 15 minutes
- **Responsive Design**: Adapts to various screen sizes and orientations

### Design & Display

- **Modern Card-Based Design**: Glassmorphism effects with performance optimizations
- **Smart Calendar**: Complete month view with adjacent month days
- **Device-Adaptive**: Optimized for tablets, smartphones, desktop monitors, and smart TVs

### Integrations

- **Real Weather Data**: Current conditions, 5-day forecast, and air quality from OpenWeatherMap
- **RSS Feed Support**: Dual news and events tickers with smooth animations
- **Google Calendar**: Optional OAuth 2.0 integration for calendar events
- **Canvas LMS**: Educational dashboard features for instructors and students
- **Traffic Patterns**: Local traffic data for commute planning

### Security & Access

- **Secure Remote Access**: Optional Tailscale integration for secure remote viewing
- **Environment-Based Configuration**: API keys managed securely
- **No Client Dependencies**: Pure HTML/CSS dashboard with no JavaScript requirements

## Architecture

```
┌─────────────────┐     ┌──────────────────┐     ┌─────────────────┐
│   Docker Host   │────▶│   Web Service    │────▶│  Display Device │
│  (Server/NAS)   │     │  (Port 8080)     │     │  (Any Browser)  │
└─────────────────┘     └──────────────────┘     └─────────────────┘
        │                        │                        │
        ▼                        ▼                        ▼
┌─────────────────┐     ┌──────────────────┐     ┌─────────────────┐
│   External APIs │     │  Static HTML     │     │   Web Browser   │
│  - Weather      │     │  (Auto-refresh)  │     │   (Fullscreen)  │
│  - RSS Feeds    │     │                  │     │                 │
│  - Calendar     │     │                  │     │                 │
│  - Canvas LMS   │     │                  │     │                 │
└─────────────────┘     └──────────────────┘     └─────────────────┘
                                                          │
                         Optional: Tailscale             ▼
                        ┌──────────────────┐     ┌─────────────────┐
                        │    TSDProxy      │     │     Display     │
                        │ (Reverse Proxy)  │     │   (Any Size)    │
                        └──────────────────┘     └─────────────────┘
```

## Quick Start

### Step 1: Deploy Dashboard Service

Deploy the dashboard web service on any system with Docker support:

```bash
# Clone repository
git clone https://github.com/your-username/universal-dashboard.git
cd universal-dashboard

# Set up environment
cp .env.example .env
# Edit .env with your API keys

# Deploy with Docker
docker compose up -d

# Access at http://localhost:8080
```

**Service Management:**

```bash
# View logs
docker compose logs -f

# Restart services
docker compose restart

# Stop services
docker compose down

# Update and rebuild
git pull && docker compose up -d --build
```

### Step 2: Configure Display Devices

The dashboard works on any device with a web browser. Here are setup instructions for common use cases:

#### Desktop/Laptop Displays

**Chrome/Edge/Firefox (Full-screen kiosk):**

```bash
# Windows
chrome.exe --kiosk --noerrdialogs --disable-infobars --incognito http://your-server:8080

# macOS
open -a "Google Chrome" --args --kiosk --noerrdialogs --disable-infobars --incognito http://your-server:8080

# Linux
google-chrome --kiosk --noerrdialogs --disable-infobars --incognito http://your-server:8080
```

#### Tablets and Smartphones

1. Open your preferred browser
2. Navigate to `http://your-server:8080`
3. Add to home screen for easy access
4. Use full-screen mode in browser settings

**iOS Safari:**
- Tap Share → Add to Home Screen
- Open from home screen for full-screen experience

**Android Chrome:**
- Menu → Add to Home screen
- Menu → Settings → Site settings → Full screen

#### Smart TVs

**Android TV/Google TV:**

1. Install Chrome or Firefox from Google Play Store
2. Navigate to dashboard URL
3. Bookmark for easy access

**Samsung Tizen/LG webOS:**

1. Use built-in browser
2. Navigate to dashboard URL
3. Add to favorites

#### Raspberry Pi (Optional Setup)

For users who want to use a Raspberry Pi as a dedicated display:

1. **Install Raspberry Pi OS Lite**
2. **Install minimal browser setup:**
   ```bash
   sudo apt update && sudo apt install -y \
       xserver-xorg xinit matchbox-window-manager \
       midori unclutter
   ```
3. **Create simple kiosk script:**
   ```bash
   cat > ~/start_dashboard.sh << 'EOF'
   #!/bin/bash
   xset -dpms; xset s off; xset s noblank
   unclutter -idle 0.5 -root &
   matchbox-window-manager -use_titlebar no &
   sleep 2
   midori -e Fullscreen -a http://your-server:8080
   EOF
   chmod +x ~/start_dashboard.sh
   ```

### Remote Access with Tailscale (Optional)

For secure access across networks:

1. **Install Tailscale on your server:**
   ```bash
   curl -fsSL https://tailscale.com/install.sh | sh
   sudo tailscale up
   ```

2. **Configure TSDProxy for easy access:**
   ```bash
   # Labels in docker-compose.yml already configured for TSDProxy
   # Access at: https://dashboard-518.your-tailnet.ts.net
   ```

## Configuration

### Environment Variables

Create a `.env` file with your API keys:

```bash
# Required for weather data
OPENWEATHER_API_KEY=your_openweather_api_key

# Optional integrations
GOOGLE_CALENDAR_CLIENT_ID=your_google_client_id
GOOGLE_CALENDAR_CLIENT_SECRET=your_google_client_secret
GOOGLE_MAPS_API_KEY=your_maps_api_key
MAPBOX_API_KEY=your_mapbox_api_key
CANVAS_BASE_URL=https://your-institution.instructure.com
CANVAS_API_KEY=your_canvas_api_key

# Display settings
WEATHER_LOCATION=Winston-Salem,NC,US
WEATHER_UNITS=imperial
PORT=8080
```

### Dashboard Configuration

Edit `src/config/config.json` to customize:

#### Weather Settings
```json
{
  "weather": {
    "location": "Your City,State,Country",
    "units": "metric",
    "timezone": "America/New_York"
  }
}
```

#### RSS Feeds
```json
{
  "rss_feeds": {
    "BBC News": "http://feeds.bbci.co.uk/news/rss.xml",
    "Tech News": "https://techcrunch.com/feed/",
    "Your Local News": "https://your-local-news.com/rss"
  }
}
```

#### Google Calendar Integration

1. Create OAuth 2.0 credentials at [Google Cloud Console](https://console.cloud.google.com/)
2. Add your dashboard URL as authorized redirect URI
3. Update `.env` with credentials
4. Configure calendars in `config.json`:

```json
{
  "calendar": {
    "calendars": {
      "personal": {
        "id": "your_calendar_id@group.calendar.google.com",
        "name": "Personal",
        "color": "#F4B400",
        "enabled": true
      }
    },
    "timezone": "America/New_York"
  }
}
```

## Device-Specific Optimizations

### Performance Settings

For older or less powerful devices, adjust display settings:

```json
{
  "display": {
    "refresh_interval": 1800,
    "theme": "dark",
    "show_seconds": false
  }
}
```

### Screen Size Adaptations

The dashboard automatically adapts to screen size, but you can optimize for specific devices:

- **Large displays (>1920px)**: All widgets displayed
- **Medium displays (768-1920px)**: Responsive grid layout
- **Small displays (<768px)**: Stacked layout optimized for mobile

## Development & Testing

### Local Development

```bash
# Clone repository
git clone https://github.com/your-username/universal-dashboard.git
cd universal-dashboard

# Set up Python environment
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt

# Configure API keys
cp .env.example .env
# Edit .env with your API keys

# Generate dashboard
python src/generate_dashboard.py

# Test locally
python -m http.server 8000 --directory output
# Open http://localhost:8000
```

### Testing

```bash
# Run tests
pytest tests/

# Test specific components
python test_dashboard.py
python test_oauth.py
```

## Troubleshooting

### Common Issues

**Dashboard not loading:**
```bash
# Check service status
docker compose ps

# View logs
docker compose logs -f

# Test connectivity
curl -I http://localhost:8080
```

**API integration issues:**
1. Verify API keys in `.env` file
2. Check service logs for authentication errors
3. Ensure API services are accessible from your network

**Display device problems:**
1. Verify network connectivity to dashboard service
2. Try different browsers
3. Check firewall settings
4. Ensure dashboard URL is correct

### Performance Optimization

**For high-traffic or multiple displays:**
- Increase `refresh_interval` in config
- Use caching proxy (nginx already included)
- Monitor resource usage with `docker stats`

**For low-power display devices:**
- Use dark theme to reduce power consumption
- Disable unnecessary widgets in config
- Reduce animation complexity in CSS

## Security Considerations

- API keys stored in environment variables (not in containers)
- Containers run as non-root users
- No external JavaScript dependencies
- OAuth tokens stored securely outside containers
- Tailscale provides end-to-end encryption for remote access

## Contributing

1. Fork the repository
2. Create feature branch: `git checkout -b feature-name`
3. Commit changes: `git commit -am 'Add feature'`
4. Push branch: `git push origin feature-name`
5. Open Pull Request

## License

MIT License - see LICENSE file for details

## Acknowledgments

- Weather data from [OpenWeatherMap](https://openweathermap.org/)
- [Tailscale](https://tailscale.com/) for secure networking
- [TSDProxy](https://github.com/almeidapaulopt/tsdproxy) for reverse proxy
- Designed for universal device compatibility
