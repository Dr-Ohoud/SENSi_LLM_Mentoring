# SENSi Evaluation Questionnaires

These are the two questionnaires administered to participants in the formative user study reported in the paper *"SENSi Agent: Translating Expert Mentoring Strategies into LLM Prompts through Cognitive Task Analysis"* (MobileHCI '26), along with the open-ended post-session questions. Both instruments were developed by the authors for this study.

---

## A1. LLM Accuracy and Consistency Questionnaire

**Scale:** 0–4 (0 = Poor, 4 = Excellent)

| Dimension | Description | Scale |
|---|---|---|
| Relevance | The response addressed the user's question and career context. | 0–4 |
| Clarity | The response was clear, coherent, and easy to understand. | 0–4 |
| Personalization | The response reflected the user's background, goals, or profile. | 0–4 |
| Motivation | The response encouraged and motivated the user to take action. | 0–4 |

**Scoring:** Each participant's four ratings are summed to a total out of 16. The overall consistency score is computed as:

```
consistency_score (%) = ( Σ (t_i / 16) / n ) × 100
```

where `t_i` is a participant's total score across the four criteria and `n` is the number of participants.

---

## A2. Usability Questionnaire

**Scale:** 1–5 (1 = Strongly Disagree, 5 = Strongly Agree)

| Construct | Question | Scale |
|---|---|---|
| Usefulness | The mentor's advice was useful for my career. | 1–5 |
| Understandability | I understood the mentor's responses easily. | 1–5 |
| Guidance / Actionability | The app helped me know what to do next. | 1–5 |
| Emotional Comfort | I felt comfortable sharing information with the mentor. | 1–5 |
| Trust | I trust the advice I received from the mentor. | 1–5 |
| Engagement & Personalization | The chat felt personal and engaging. | 1–5 |
| Enjoyability | I enjoyed using the app. | 1–5 |
| Reuse Intention | I would use this mentor again. | 1–5 |
| Overall Satisfaction | Rate your overall experience with using the app. | 1–5 |

---

## Open-Ended Questions

| Question | Purpose |
|---|---|
| What did you like most about the experience? | Identify perceived strengths. |
| What would you change or improve? | Collect qualitative feedback and suggestions. |

---

### Reference

Please cite the SENSi paper (MobileHCI '26) if you use or adapt these instruments:

> Shahad A. Bagarish, Ahmed Sabbir Arif, and Ohoud Mosa Alharbi. 2026. SENSi Agent: Translating Expert Mentoring Strategies into LLM Prompts through Cognitive Task Analysis. In *28th International Conference on Mobile Human-Computer Interaction (MobileHCI '26), August 31–September 03, 2026, Swansea, United Kingdom*. ACM, New York, NY, USA. https://doi.org/10.1145/3821581.3833111

```bibtex
@inproceedings{bagarish2026sensi,
  author    = {Bagarish, Shahad A. and Arif, Ahmed Sabbir and Alharbi, Ohoud Mosa},
  title     = {{SENSi} Agent: Translating Expert Mentoring Strategies into {LLM} Prompts through Cognitive Task Analysis},
  booktitle = {28th International Conference on Mobile Human-Computer Interaction (MobileHCI '26)},
  year      = {2026},
  publisher = {ACM},
  address   = {New York, NY, USA},
  location  = {Swansea, United Kingdom},
  doi       = {10.1145/3821581.3833111},
  url       = {https://doi.org/10.1145/3821581.3833111}
}
```
