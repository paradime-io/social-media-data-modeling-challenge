{% macro calculate_performance_scores(total, top50_count, top10_count, avg_top50_rank, avg_top10_rank) %}
    0.3 * {{ total }} +
    0.2 * {{ top50_count }} +
    0.2 * {{ top10_count }} +
    0.15 * {{ avg_top50_rank }} +
    0.15 * {{ avg_top10_rank }} AS base_performance_score,
    0.1 * {{ total }} +
    0.35 * {{ top50_count }} +
    0.1 * {{ top10_count }} +
    0.35 * {{ avg_top50_rank }} +
    0.1 * {{ avg_top10_rank }} AS consistency_score,
    0.1 * {{ total }} +
    0.1 * {{ top50_count }} +
    0.35 * {{ top10_count }} +
    0.1 * {{ avg_top50_rank }} +
    0.35 * {{ avg_top10_rank }} AS peak_score
{% endmacro %}