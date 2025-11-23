# Note: this function was provided by NIWA https://niwa.co.nz and has been
# refactored and adapted for this tutorial.

def function(building, hazard_depth):
    DS_1_Prob = 0.0
    DS_2_Prob = 0.0
    DS_3_Prob = 0.0
    DS_4_Prob = 0.0
    DS_5_Prob = 0.0

    construction = building["Cons_Frame"]

    if hazard_depth is not None and hazard_depth > 0:
        DS_1_Prob = log_normal_cdf(hazard_depth, -0.53, 0.46)

        if construction in ['Masonry', 'Steel']:
            DS_2_Prob = log_normal_cdf(hazard_depth, 0.50, 0.30)
            DS_3_Prob = log_normal_cdf(hazard_depth, 1.00, 0.42)
            DS_4_Prob = log_normal_cdf(hazard_depth, 1.50, 0.5)
            DS_5_Prob = log_normal_cdf(hazard_depth, 2.00, 0.59)

        elif construction in ['Reinforced_Concrete', 'Reinforced Concrete']:
            DS_2_Prob = log_normal_cdf(hazard_depth, 0.50, 0.045)
            DS_3_Prob = log_normal_cdf(hazard_depth, 1.00, 0.06)
            DS_4_Prob = log_normal_cdf(hazard_depth, 1.50, 0.09)
            DS_5_Prob = log_normal_cdf(hazard_depth, 2.00, 0.12)
        else:  # Timber or unknown
            DS_2_Prob = log_normal_cdf(hazard_depth, 0.50, 0.30)
            DS_3_Prob = log_normal_cdf(hazard_depth, 1.00, 0.45)
            DS_4_Prob = log_normal_cdf(hazard_depth, 1.5, 0.55)
            DS_5_Prob = log_normal_cdf(hazard_depth, 2.00, 0.65)

    return {
        'DS_1': DS_1_Prob,
        'DS_2': DS_2_Prob,
        'DS_3': DS_3_Prob,
        'DS_4': DS_4_Prob,
        'DS_5': DS_5_Prob
    }

def log_normal_cdf(x, mean, stddev):
    return functions.get('lognorm_cdf').call(x, mean, stddev)
