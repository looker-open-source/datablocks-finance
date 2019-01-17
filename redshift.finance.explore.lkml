include: "redshift.*.view*"

explore: rs_financial_indicators {
  view_label: "Indicator"
  join: rs_indicators_metadata_codes {
    view_label: "Indicator Details"
    type: left_outer
    sql_on: ${rs_financial_indicators.dataset_code} = ${rs_indicators_metadata_codes.dataset_code} ;;
    relationship: one_to_one
  }
  join: rs_indicators_metadata {
    view_label: "Indicator Details"
    type: left_outer
    sql_on: ${rs_financial_indicators.dataset_code} = ${rs_indicators_metadata.dataset_code} ;;
    relationship: many_to_one
  }

  join: rs_indicator_yoy_facts {
    type: left_outer
    relationship: many_to_one
    sql_on: ${rs_indicator_yoy_facts.dataset_code} = ${rs_financial_indicators.dataset_code}
      and ${rs_financial_indicators.indicator_year} = ${rs_indicator_yoy_facts.indicator_year}  ;;
  }
}
