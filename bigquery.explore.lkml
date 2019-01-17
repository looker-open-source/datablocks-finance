include: "bigquery.*.view*"

explore: bq_financial_indicators {
  view_label: "Indicator"
  join: bq_indicators_metadata_codes {
    view_label: "Indicator Details"
    type: left_outer
    sql_on: ${bq_financial_indicators.dataset_code} = ${bq_indicators_metadata_codes.dataset_code} ;;
    relationship: one_to_one
  }
  join: bq_indicators_metadata {
    view_label: "Indicator Details"
    type: left_outer
    sql_on: ${bq_financial_indicators.dataset_code} = ${bq_indicators_metadata.dataset_code} ;;
    relationship: many_to_one
  }

  join: bq_indicator_yoy_facts {
    type: left_outer
    relationship: many_to_one
    sql_on: ${bq_indicator_yoy_facts.dataset_code} = ${bq_financial_indicators.dataset_code}
      and ${bq_financial_indicators.indicator_year} = ${bq_indicator_yoy_facts.indicator_year}  ;;
  }
}
