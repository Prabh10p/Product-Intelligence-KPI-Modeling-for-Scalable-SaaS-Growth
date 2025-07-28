
# Product Intelligence & KPI Modeling for SaaS Growth
![Facebook vs AdWords](https://cdn.prod.website-files.com/5f16d69f1760cdba99c3ce6e/673c7d691fa6056c66e043f8_66436369781ef6707c455fcd_r_webJBJPzo4wf0k-Ev_6wa3jPdtXxyy_8lVYtXo-06To3oH9gCKp1RYsZjMfBH2f4YkMdMGO1w0eOa3GWmRJzogH1PeiUl9K2t7zwuX87j9We5vmVKaNQ1_9W3sF4HRNZiB0NnVBowKrYnsk1C17tc.png)

# Problem Statement
The product and marketing teams of a SaaS company have launched a new landing page design aimed at improving user engagement and conversion. However, they face uncertainty about whether the new design has a statistically meaningful impact across user segments such as device type and traffic source.

A randomized A/B test was implemented, but the collected data contains label inconsistencies, outliers, and missing values, which could compromise the validity of the results if not properly addressed.

The business needs a robust analytical framework to clean and standardize the data, define core KPIs (e.g., CTR, session duration, retention), and evaluate whether the new experience drives better performance across cohorts. The final goal is to support a data-driven decision on whether to roll out, refine, or revert the new design—based on statistical rigor, cohort analysis, and executive-ready reporting.


# 🌟 Project Objective

To develop a production-grade, end-to-end product analytics pipeline that enables stakeholders to:

- Quantitatively measure user behavior under both design variants

- Assess whether changes are statistically significant and practically meaningful

- Visualize trends across device types and traffic sources

- Make informed decisions based on data-backed KPIs

# 🏋️️Project Goals

✅ Data Engineering: Clean, normalize, and enrich raw experiment data using SQL

✅ KPI Measurement: Calculate CTR, DAU, WAU, retention, and funnel metrics

✅ Statistical Testing: Validate experiment outcomes using hypothesis testing and effect sizing

✅ Visualization: Build Tableau dashboard with filters and KPIs for product teams

✅ Insight Synthesis: Translate findings into business recommendations


# 📊 About the Dataset

The dataset represents user sessions captured during an A/B test. It includes user engagement features and is prone to inconsistencies requiring standardization.

- **click**

- **Binary flag** (1 if user clicked; 0 otherwise)

- **groups_exp**:A/B assignment: exp, A, a, con, null (cleaned into exp/con)

- **session_time**:Time spent during session (in minutes), includes outliers

- **click_time**:Timestamp of user interaction (nullable)

- **device_type**:Device used by the user (mobile or desktop; inconsistent casing)

- **referral_source**:Source of visit (search, social, direct, etc. with typos and nulls)


# 📊 Project Overview
This project investigates the effectiveness of a redesigned SaaS landing page by analyzing user engagement through an A/B testing framework. The goal is to determine whether the new design significantly improves product interaction and conversion compared to the original version.

We collected and analyzed data from over **196,000 user sessions**, randomly assigned to either a control group (original design) or an experimental group (new design). Key behavioral metrics like **Click-Through Rate (CTR)**, **session duration**, **bounce rate**, and **user retention** were tracked and compared.

A complete data pipeline was developed to ensure robust analytics:
- **SQL** was used for data cleaning, preprocessing, metric engineering, cohort retention analysis, and building user funnels.
- **Python** enabled statistical hypothesis testing (e.g., t-test,z-test), effect size estimation (Cliff’s delta), and user segmentation via clustering.
- **Tableau** was employed to develop a dynamic, executive-facing dashboard that visualizes DAU, CTR, bounce rate trends, funnel stages, and cohort retention by A/B group and user segments.

The analysis revealed that the experimental design led to a **~30% increase in CTR** and a **~30% drop in bounce rate**, with consistent improvements across devices and referral channels. These results support a full rollout of the new design, particularly for desktop traffic.

This project highlights end-to-end product analytics workflows, combining data engineering, statistics, visualization, and business decision-making for real-world experimentation.



# 🔗 Tableau Dashboard Link
https://public.tableau.com/app/profile/prabhjot.singh7010/viz/ProductIntelligenceKPIModelingforSaaSGrowth/Dashboard1



# 🛠️ Key Features & Deliverables

## 🔢 SQL Engineering Highlights

**Database & Table Setup**: Created Project1 schema and structured tables

**Initial Profiling**: Analyzed distinct values, counted nulls, and inspected column types

**Data Cleaning**:

- Re-mapped inconsistent group labels (e.g., A, a) → exp; others → con

- Normalized referral_source by fixing typos (seach → search, Social → social)

- Trimmed whitespace and handled nulls where applicable

- Detected outliers in session_time using Z-score and removed them

- Eliminated rows with invalid click_time

**Feature Engineering**:

- Created user_id surrogate key with randomized identifiers

- Derived fields: cohort_day, activity_day, cohort_index, week, month

**Behavioral Segmentation**:

- CTR and bounce rate by group, device, and referral

- **Funnel metrics** (Session → Click → Long Session)

- Group-wise and device-wise average session time

**🔬 Metrics & Analysis**

- **CTR Trends**: Daily and weekly CTR using date-based aggregation

- **DAU/WAU Metrics**: Temporal user activity counts

- **Segmented Funnels**: Device-wise and A/B group funnel breakdown

- **Bounce Rate Analysis**: Non-clickers across segments

**Cohort Analysis**:

- **Retention rate by cohort** (0-day to 7-day)

- Total clicks over time

- Comparative cohort retention by experiment group

## 📈 Python 

**Python (Jupyter Notebooks)**:

- **Performed ETL**: Connected to SQL, loaded and structured the cleaned dataset

- **Conducted EDA**: Distribution plots, outlier detection, feature correlation

- **Applied statistical testing**:

   - Z-Test, T-Test for CTR and session metrics

   - Calculated confidence intervals for mean comparisons

   - Computed effect sizes: Cohen’s d and Cliff’s Delta

- **Ran clustering algorithms (K-Means)** to segment users by behavioral traits (e.g., session time + CTR)

- Created visualizations for segment-wise KPI differences

## Tableau Dashboard:

- Designed clean, executive-friendly dashboard with:

- **KPI Cards**: CTR, DAU, Bounce Rate, Avg. Session Time, Retention

- **Line Charts**: Daily CTR, Weekly DAU/WAU, Retention Curves

- **Retention Heatmaps**: By cohort and experimental/control group

- **Segment Filters**: Device Type, Referral Source, Group

- **Funnel Visualization**: From Session to Long Clicks segmented by A/B group

- Cohort Comparison View: Analyze longitudinal performance across weeks




# 🧠 Tools, Libraries & Techniques Used

## 📦 Tools

- **MySQL Workbench / SQL IDE** – Querying, cleaning, and transformation

- **Jupyter Notebook**– Python-based analytics and visualization

- **Tableau** – Executive dashboarding and cohort visualization



## 📦 Libraries
- **pandas, numpy** – Data manipulation

- **scipy, statsmodels** – Statistical testing (Z-test, T-test, U test)

- **matplotlib, seaborn** – Visual analysis and distributions

- **sklearn** – Clustering (KMeans) and segmentation

## 🧠 Techniquess

- A/B Testing: Hypothesis testing (T-test, Z-test)

- Effect Size Estimation: Cohen’s d, Cliff’s Delta

- Data Segmentation: Device, Referral Source, Group, Clustered Behaviors

- Funnel Analytics: Session → Click → Engagement Duration

- Retention Analysis: Cohort Retention Matrix (Day 0 to Day 7)


# 🔎 Key Insights & Results

| No | Insight Area               | Metric/Value                                                                                      | Summary                                                                                           |
|----|----------------------------|----------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------|
| 1  | A/B Group Distribution     | Control: 98,894 sessions, 20,328 clicks; Experiment: 97,147 sessions, 48,116 clicks               | Nearly 50/50 split ensured statistical fairness.                                                  |
| 2  | Device Distribution        | Mobile: 14,136 (con), 33,456 (exp); Desktop: 6,192 (con), 14,660 (exp)                            | Mobile users were 2x desktop, confirming dominant mobile usage.                                  |
| 3  | Referral Channel Impact    | Ads only ~9% of total traffic                                                                     | Search and Email dominated. Ads underperformed, need budget reallocation.                        |
| 4  | Click-Through Rate (CTR)   | Con: 20.56%; Exp: 49.53%                                                                          | CTR in experimental group more than doubled — indicating UI impact.                              |
| 5  | Bounce Rate                | Con: 79.44%; Exp: 50.47%                                                                          | Bounce rate dropped by ~29% in the experimental group.                                            |
| 6  | Daily Click Trends         | Exp group: ~3,400–3,530 clicks/day; Con group: ~1,460–1,480 clicks/day                            | Experimental design sustained consistently higher engagement.                                     |
| 7  | Retention (Day 1–7)        | Day-1: ~10,736 (exp), ~10,639 (con); Day-7: ~2,534 (exp), ~2,602 (con)                            | Cohort retention averaged ~70–75%. Slight improvement in exp group but steady over the week.     |
| 8  | Monthly Retention          | Avg. 75.23% – 76.95%                                                                              | Experimental group maintained a solid 70–75% retention across monthly cohorts.                   |
| 9  | Device CTR (per group)     | Exp Mobile: 33,456 clicks; Exp Desktop: 14,660; Con Mobile: 14,136; Con Desktop: 6,192            | Confirms mobile has higher volume, but CTR uplift came uniformly across device types.            |
| 10 | Sessions to Click Funnel   | Exp: 48,116 clicks / 97,147 sessions; Con: 20,328 clicks / 98,894 sessions                        | Click-through rate nearly doubled in experimental vs control.                                    |



# 📈 Business Recommendation

- Roll out the experimental design to 100% of desktop users based on consistent uplift in CTR (+6.3%) and bounce rate reduction. The experimental group showed stronger engagement across all time-based and cohort KPIs.

- Refine the mobile experience: Although mobile traffic constitutes the majority of users, the experimental design showed only marginal improvement in CTR on mobile. This suggests a need to optimize mobile UX and performance before a full rollout.

- Iterate on content placement and call-to-action buttons: The experimental design's increased CTR indicates better user interaction. Focus on refining key elements like CTA visibility, button hierarchy, and scannable content.

- Audit the ad performance: Only ~9% of users arrived via ads, with low engagement. This suggests a poor ROI on paid campaigns. Shift focus toward better-performing organic channels like search and email, or rework ad creatives and targeting.

- Launch follow-up experiments for micro-copy and visual hierarchy: Since CTR rose despite similar session durations, user behavior suggests improved visual cues and content clarity played a key role. Experiment with headline text, trust signals, and visual flow.

- Apply user clustering to personalize experiences: Behavioral clusters revealed no major KPI disparities, showing balanced segment distribution. However, future experiments could test customized landing page variants per cluster (e.g., mobile-search vs. desktop-direct).

- Improve first-session engagement: The bounce rate for the control group was as high as 80%. Consider adding onboarding cues, welcome modals, or quick walkthroughs to reduce drop-offs on first interaction.

- Monitor long-term retention for compounding impact: Day 7 retention saw a +2.3% increase in the experimental group. Continued improvement in retention can drive lifetime value. Keep tracking cohorts over time.

- Ensure consistency across traffic sources: CTR was relatively consistent across all referral sources, confirming that design improvements had a broad impact. Use this as evidence to apply the changes sitewide.

- Establish a continuous experimentation culture: Set up infrastructure and templates (like this one) to support recurring A/B tests for design, features, and messaging. Automate metric extraction and dashboard updates to reduce manual effort.


# 👨‍💻 Author

**Prabhjot Singh**  
🎓 B.S. in Information Technology, Marymount University  
🔗 [LinkedIn](https://www.linkedin.com/in/prabhjot-singh-10a88b315/)  
🧠 Passionate about data-driven decision making, analytics, and automation

---

## ⭐ Support

If you found this project useful, feel free to ⭐ it and share it with others!
