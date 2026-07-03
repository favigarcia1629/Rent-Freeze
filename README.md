# NYC Rent Freeze Analysis

**What does Zohran Mamdani's rent freeze proposal actually mean for tenants and landlords?**

NYC has ~890,000 rent-stabilized apartments housing over 2 million tenants. This project analyzes the economic impact of a rent freeze on both sides — using real data from the NYC Rent Guidelines Board, BLS CPI, and Census ACS.

---

## Key Findings

| Question | Finding |
|---|---|
| Have rents outpaced inflation? | Yes — rents rose 117% since 2010 vs 69% inflation, 58% wage growth |
| What is the stabilized/market rent gap? | $1,400/month on average — up to $2,350/month in Manhattan |
| Who benefits from the freeze? | 59% of stabilized tenants earn under $50K/year |
| What happens to landlords? | Net income turns negative by 2027 as operating costs rise 5%/yr |

---

## Project Structure

```
rent_freeze/
├── analysis.R         # Full R analysis — data, charts, findings
├── generate_pdf.py    # PDF write-up generator
└── README.md
```

---

## Charts

1. **Rent vs. Inflation vs. Wages** — indexed to 2010, showing rent has outpaced both
2. **Stabilized vs. Market Rent by Borough** — the rent gap across all 5 boroughs
3. **Who Benefits?** — income distribution of stabilized vs. market tenants
4. **Landlord Economics** — net income projection under a frozen rent scenario (2025–2030)

---

## Setup

```r
# Install required packages in R
install.packages(c("tidyverse", "plotly", "scales"))

# Open analysis.R in RStudio, select all, and run (Cmd+A, Cmd+Enter)
```

---

## Methodology

**Rent vs. Inflation** — NYC median rents indexed against BLS CPI and median wages, all set to 100 in 2010 for direct comparison.

**Borough Data** — Stabilized unit counts and rent levels from the NYC Housing and Vacancy Survey and DHCR. Market rents from StreetEasy/NYC RGB data.

**Who Benefits** — Income distribution of stabilized vs. market-rate tenants from Census ACS and the NYC Housing and Vacancy Survey.

**Landlord Model** — Per-unit annual revenue frozen at 2025 levels, fixed mortgage of $12,000/year, operating costs increasing 5%/year per NYC RGB cost data.

---

## Data Sources

| Source | Data |
|---|---|
| NYC Rent Guidelines Board | Rent levels, operating cost data |
| BLS CPI | Inflation index (2010–2025) |
| Census ACS | Tenant income distribution |
| NYC Housing and Vacancy Survey | Stabilized unit counts by borough |
| DHCR | Stabilization status data |

---

*Built for research and education. Not policy advice.*
