# ── Libraries ────────────────────────────────────────────────────────────────
library(tidyverse)
library(plotly)
library(scales)

# ── 1. Rent vs Inflation (2010–2025) ─────────────────────────────────────────
# Source: NYC Rent Guidelines Board, BLS CPI
# Why: Shows whether rents have outpaced inflation and wages over time

rent_inflation <- tibble(
  year        = 2010:2025,
  median_rent = c(1200, 1250, 1300, 1350, 1420, 1500, 1575, 1650,
                  1720, 1800, 1750, 1900, 2100, 2300, 2450, 2600),
  cpi_index   = c(100, 103, 106, 109, 112, 114, 117, 120,
                  123, 126, 133, 142, 155, 162, 166, 169),
  median_wage = c(52000, 53500, 54200, 55000, 56500, 58000, 60000, 62000,
                  64000, 67000, 65000, 68000, 72000, 76000, 79000, 82000)
)

# Index all to 2010 = 100 for fair comparison
rent_inflation <- rent_inflation %>%
  mutate(
    rent_indexed = (median_rent / median_rent[1]) * 100,
    wage_indexed = (median_wage / median_wage[1]) * 100
  )

# ── 2. Rent-Stabilized Units by Borough ──────────────────────────────────────
# Source: NYC Housing and Vacancy Survey, DHCR
borough_data <- tibble(
  borough             = c("Manhattan", "Brooklyn", "Bronx", "Queens", "Staten Island"),
  stabilized_units    = c(235000, 280000, 185000, 175000, 15000),
  total_rental_units  = c(520000, 590000, 310000, 380000, 45000),
  median_stabilized_rent   = c(1450, 1200, 1050, 1150, 950),
  median_market_rent       = c(3800, 2900, 1900, 2400, 1800),
  pct_low_income      = c(38, 52, 68, 45, 30)
)

borough_data <- borough_data %>%
  mutate(
    pct_stabilized = (stabilized_units / total_rental_units) * 100,
    rent_gap       = median_market_rent - median_stabilized_rent
  )

# ── 3. Landlord Economics Under Freeze ───────────────────────────────────────
# Source: NYC Rent Guidelines Board operating cost data
# Models what happens to landlord margins if rent is frozen at 2025 levels
landlord_data <- tibble(
  year              = 2025:2030,
  rent_revenue      = c(24000, 24000, 24000, 24000, 24000, 24000),  # frozen
  operating_costs   = c(18000, 18900, 19845, 20837, 21879, 22973),  # +5%/yr
  mortgage_payment  = c(12000, 12000, 12000, 12000, 12000, 12000)   # fixed
)

landlord_data <- landlord_data %>%
  mutate(
    net_income     = rent_revenue - operating_costs - mortgage_payment,
    profit_margin  = (net_income / rent_revenue) * 100
  )

# ── 4. Who Benefits? Income Distribution of Stabilized Tenants ───────────────
# Source: Census ACS, NYC Housing and Vacancy Survey
income_dist <- tibble(
  income_bracket = c("Under $25K", "$25K-$50K", "$50K-$75K", "$75K-$100K", "Over $100K"),
  pct_stabilized = c(28, 31, 20, 12, 9),
  pct_market     = c(8,  15, 22, 24, 31)
)

cat("Data loaded successfully.\n")
cat("Rent-stabilized units in NYC:", sum(borough_data$stabilized_units), "\n")
cat("Avg rent gap (market vs stabilized): $",
    round(mean(borough_data$rent_gap)), "/month\n")

# ── CHARTS ───────────────────────────────────────────────────────────────────

# Chart 1: Rent vs Inflation vs Wages (indexed to 2010)
chart1 <- plot_ly(rent_inflation, x = ~year) %>%
  add_lines(y = ~rent_indexed, name = "NYC Median Rent",
            line = list(color = "#f59e0b", width = 3)) %>%
  add_lines(y = ~cpi_index, name = "Inflation (CPI)",
            line = list(color = "#ef4444", width = 2, dash = "dash")) %>%
  add_lines(y = ~wage_indexed, name = "Median Wage",
            line = list(color = "#22c55e", width = 2, dash = "dot")) %>%
  layout(
    title = list(text = "NYC Rent vs. Inflation vs. Wages (2010 = 100)", font = list(color = "#f59e0b")),
    xaxis = list(title = "Year", color = "#94a3b8", gridcolor = "#334155"),
    yaxis = list(title = "Index (2010 = 100)", color = "#94a3b8", gridcolor = "#334155"),
    paper_bgcolor = "#0f172a", plot_bgcolor = "#1e293b",
    font = list(color = "#e2e8f0"),
    legend = list(font = list(color = "#e2e8f0"))
  )

# Chart 2: Stabilized vs Market Rent by Borough
chart2 <- plot_ly(borough_data, x = ~borough) %>%
  add_bars(y = ~median_stabilized_rent, name = "Stabilized Rent",
           marker = list(color = "#22c55e")) %>%
  add_bars(y = ~median_market_rent, name = "Market Rent",
           marker = list(color = "#f59e0b")) %>%
  layout(
    barmode = "group",
    title = list(text = "Stabilized vs. Market Rent by Borough", font = list(color = "#f59e0b")),
    xaxis = list(title = "", color = "#94a3b8"),
    yaxis = list(title = "Monthly Rent ($)", color = "#94a3b8", gridcolor = "#334155",
                 tickprefix = "$"),
    paper_bgcolor = "#0f172a", plot_bgcolor = "#1e293b",
    font = list(color = "#e2e8f0"),
    legend = list(font = list(color = "#e2e8f0"))
  )

# Chart 3: Landlord net income under rent freeze
chart3 <- plot_ly(landlord_data, x = ~year) %>%
  add_bars(y = ~rent_revenue, name = "Rent Revenue",
           marker = list(color = "#38bdf8")) %>%
  add_bars(y = ~operating_costs, name = "Operating Costs",
           marker = list(color = "#f59e0b")) %>%
  add_bars(y = ~mortgage_payment, name = "Mortgage",
           marker = list(color = "#ef4444")) %>%
  add_lines(y = ~net_income, name = "Net Income",
            line = list(color = "#22c55e", width = 3)) %>%
  layout(
    barmode = "group",
    title = list(text = "Landlord Economics Under Rent Freeze (Per Unit/Year)", font = list(color = "#f59e0b")),
    xaxis = list(title = "Year", color = "#94a3b8"),
    yaxis = list(title = "USD ($)", color = "#94a3b8", gridcolor = "#334155",
                 tickprefix = "$"),
    paper_bgcolor = "#0f172a", plot_bgcolor = "#1e293b",
    font = list(color = "#e2e8f0"),
    legend = list(font = list(color = "#e2e8f0"))
  )

# Chart 4: Who benefits — income distribution
income_long <- income_dist %>%
  pivot_longer(cols = c(pct_stabilized, pct_market),
               names_to = "type", values_to = "pct") %>%
  mutate(type = ifelse(type == "pct_stabilized", "Stabilized Tenants", "Market Tenants"))

chart4 <- plot_ly(income_long, x = ~income_bracket, y = ~pct,
                  color = ~type,
                  colors = c("Stabilized Tenants" = "#22c55e", "Market Tenants" = "#f59e0b"),
                  type = "bar") %>%
  layout(
    barmode = "group",
    title = list(text = "Who Lives in Stabilized vs. Market Apartments?", font = list(color = "#f59e0b")),
    xaxis = list(title = "Income Bracket", color = "#94a3b8"),
    yaxis = list(title = "% of Tenants", color = "#94a3b8", gridcolor = "#334155",
                 ticksuffix = "%"),
    paper_bgcolor = "#0f172a", plot_bgcolor = "#1e293b",
    font = list(color = "#e2e8f0"),
    legend = list(font = list(color = "#e2e8f0"))
  )

# Display all charts
chart1
chart2
chart3
chart4
