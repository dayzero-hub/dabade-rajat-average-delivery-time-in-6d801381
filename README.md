# Swiggy Instamart — Delivery Time Regression Analysis

> **DayZer0 Project** · Data Analyst · Hard

## The Problem

You've joined Swiggy Instamart's Operations Analytics team in Hyderabad.

Instamart added 12 new dark stores across 6 cities last quarter (Hyderabad, Chennai, Kolkata, Ahmedabad, Surat, Jaipur) to reduce delivery times. The result was the opposite — average delivery time increased from **18.3 → 22.5 minutes** (+4.2 min) and customer CSAT on delivery speed fell from **4.4 → 3.9/5**.

Leadership wants a root cause before committing to the next 20 stores. That's your job.

---

## Your Deliverables

1. Is the regression from **new stores or existing stores**, and which cities?
2. Break delivery time into its three phases — **pick → pack → last-mile** — and find the bottleneck
3. Give **2–3 specific operational fixes** with estimated improvement in minutes

---

## Dataset

Download `instamart_orders_q1_2025.csv` from your DayZer0 workspace and place it in the `data/` folder.

| Column | Description |
|---|---|
| `order_id` | Unique order identifier |
| `store_id` | Dark store identifier |
| `city` | City name |
| `store_type` | `new` or `existing` |
| `pick_start_ts` | Timestamp when picker started collecting items |
| `pack_end_ts` | Timestamp when packing was complete |
| `dispatch_ts` | Timestamp when rider picked up the order |
| `delivered_ts` | Timestamp when order was delivered |
| `distance_km` | Last-mile distance in km |
| `rider_id` | Rider identifier |

---

## Getting Started

### 1. Set up your environment

```bash
python -m venv .venv
source .venv/bin/activate      # Windows: .venv\Scripts\activate
pip install -r requirements.txt
```

### 2. Derive the time components

The dataset has raw timestamps. Compute the three delivery phases first:

```python
import pandas as pd

df = pd.read_csv('data/instamart_orders_q1_2025.csv',
                 parse_dates=['pick_start_ts', 'pack_end_ts', 'dispatch_ts', 'delivered_ts'])

df['pick_time_min']     = (df['pack_end_ts']  - df['pick_start_ts']).dt.total_seconds() / 60
df['pack_time_min']     = (df['dispatch_ts']  - df['pack_end_ts']).dt.total_seconds()   / 60
df['lastmile_time_min'] = (df['delivered_ts'] - df['dispatch_ts']).dt.total_seconds()   / 60
df['total_time_min']    = (df['delivered_ts'] - df['pick_start_ts']).dt.total_seconds() / 60
```

### 3. Open the starter notebook

```bash
jupyter notebook analysis/notebook.ipynb
```

### 4. Branch and commit your work

```bash
git checkout -b analysis/delivery-regression
# ... do your work ...
git add analysis/ sql/
git commit -m "Add delivery time breakdown analysis"
git push origin analysis/delivery-regression
```

Then open a Pull Request — your AI manager **Priya** will review it.

---

## How to Submit

When your analysis is ready, go back to your **DayZer0 workspace** and submit your written summary there. Your score is based on 6 dimensions (total /120).
