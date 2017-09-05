include: "bq.*.view*"

explore: financial_indicators {
  view_label: "Indicator"
  join: indicators_metadata_codes {
    view_label: "Indicator Details"
    type: left_outer
    sql_on: ${financial_indicators.dataset_code} = ${indicators_metadata_codes.dataset_code} ;;
    relationship: one_to_one
  }
  join: indicators_metadata {
    view_label: "Indicator Details"
    type: left_outer
    sql_on: ${financial_indicators.dataset_code} = ${indicators_metadata.dataset_code} ;;
    relationship: many_to_one
  }

  join: indicator_yoy_facts {
    type: left_outer
    relationship: many_to_one
    sql_on: ${indicator_yoy_facts.dataset_code} = ${financial_indicators.dataset_code}
      and ${financial_indicators.indicator_year} = ${indicator_yoy_facts.indicator_year}  ;;
  }
}
