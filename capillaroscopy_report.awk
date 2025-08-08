BEGIN {
    capillary_regex="([L|R][0-9]{1,2}).+?[ ]{2}Capillary[ ]+?Objects[ ]+?([0-9]{1,2})";
    giant_regex="([L|R][0-9]{1,2}).+?(Giant Capillary)[ ]+?Objects[ ]+?([0-9]{1,2})";
    enlarged_regex="([L|R][0-9]{1,2}).+?Enlarged Loop[ ]+?Objects[ ]+?([0-9]{1,2})";
    hemorrhage_regex="([L|R][0-9]{1,2}).+?Hemorrhage[ ]+?Objects[ ]+?([0-9]{1,2})";
    
    # pdftotext sometimes has trouble identifying the whole word; the regex may need to be tweaked to account for that
    ramification_regex="([L|R][0-9]{1,2}).+?Ramification[ ]+?Objects[ ]+([0-9]{1,2})";
    disorganization_regex="([L|R][0-9]{1,2}).+?Disorganisation[ ]+?Objects[ ]+([0-9]{1,2})";

    total_capillary_count = 0;
    images_with_capillaries = 0;

    split("R2-R3-R4-R5", right, "-");
    split("L2-L3-L4-L5", left, "-");

    # No autovivification in Awk :(
    delete digit_image_count[0];
    delete enlarged;
    delete hemorrhage;

    giants = "no";
}

# Skips first lines (summary table in the PDF)
NR < 20 {next;}
NR == 20 { RS="Comment";}

match($0, capillary_regex, arr) {
    #print arr[1] " Capillaries " arr[2];
    images_with_capillaries++;
    digit_image_count[arr[1]]++;
    capillary_count[arr[1]] += arr[2];
    total_capillary_count += arr[2];
}
match($0, giant_regex, arr) {
    #print arr[1] " Giant " arr[2];
    giant_count[arr[1]] += arr[3];
}
match($0, enlarged_regex, arr) {
    #print arr[1] " Enlarged " arr[2];
    delete dict;
    for (i in enlarged) {
        dict[enlarged[i]] = "";
    }
    if (!(arr[1] in dict)) {
        enlarged[length(dict) + 1] = arr[1];
    }
    enlarged_count[arr[1]] += arr[2];
}
match($0, hemorrhage_regex, arr) {
    #print arr[1] " Hemorrhage " arr[2];
    delete dict1;
    for (i in hemorrhage) {
        dict1[hemorrhage[i]] = "";
    }
    if (!(arr[1] in dict1)) {
        hemorrhage[length(dict1) + 1] = arr[1];
    }
    hemorrhage_count[arr[1]] += arr[2];
}
match($0, ramification_regex, arr) {
    #print arr[1] " Ramification " arr[2];
    ramification_count[arr[1]] += arr[2];
}
match($0, disorganization_regex, arr) {
    #print arr[1] " Disorganization " arr[2];
    disorganization_count[arr[1]] += arr[2];
}

END {
    printf FILENAME, "\r\n";
    printf "\r\n\r\n"
    printf "Right hand:\r\n";
    for (i=1; i <= length(right); i++) {
        printf "  %s: %.0f capillaries", right[i], capillary_count[right[i]]/digit_image_count[right[i]] + 0.4;
        if (giant_count[right[i]] > 0) {
            giant_avg_rt = giant_count[right[i]]/digit_image_count[right[i]] + 0.4;
            if (giant_avg_rt <= 1) {
                printf ", %.0f giant capillary", giant_avg_rt;
            } else {
                printf ", %.0f giant capillaries", giant_avg_rt;
            }
            giants = "yes";
        }
        if (enlarged_count[right[i]] > 0) {
            enlarged_avg_rt = enlarged_count[right[i]]/digit_image_count[right[i]] + 0.4;
            if (enlarged_avg_rt <= 1) {
                printf ", %.0f enlarged loop", enlarged_avg_rt;
            } else {
                printf ", %.0f enlarged loops", enlarged_avg_rt;
            }
        }
        if (hemorrhage_count[right[i]] > 0) {
            hemorrhage_avg_rt = hemorrhage_count[right[i]]/digit_image_count[right[i]] + 0.4;
            if (hemorrhage_avg_rt <= 1) {
                printf ", %.0f hemorrhage", hemorrhage_avg_rt;
            } else {
                printf ", %.0f hemorrhages", hemorrhage_avg_rt;
            }
        }
        if (ramification_count[right[i]] > 0) {
            ramification_avg_rt = ramification_count[right[i]]/digit_image_count[right[i]] + 0.4;
            if (ramification_avg_rt <= 1) {
                printf ", %.0f ramification", ramification_avg_rt;
            } else {
                printf ", %.0f ramifications", ramification_avg_rt;
            }
        }
        if (disorganization_count[right[i]] > 0) {
            disorganization_avg_rt = disorganization_count[right[i]]/digit_image_count[right[i]] + 0.4;
            if (disorganization_avg_rt <= 1) {
                printf ", %.0f disorganized loop", disorganization_avg_rt;
            } else {
                printf ", %.0f disorganized loops", disorganization_avg_rt;
            }
        }
        printf "\r\n";
    }

    printf "Left hand:\r\n";
    for (i=1; i <= length(left); i++) {
        printf "  %s: %.0f capillaries", left[i], capillary_count[left[i]]/digit_image_count[left[i]] + 0.4;
        #print giant_count[left[i]]
        if (giant_count[left[i]] > 0) {
            giant_avg_lt = giant_count[left[i]]/digit_image_count[left[i]] + 0.4;
            if (giant_avg_lt <= 1) {
                printf ", %.0f giant capillary", giant_avg_lt;
            } else {
                printf ", %.0f giant capillaries", giant_avg_lt;
            }
            giants = "yes";
        }
        if (enlarged_count[left[i]] > 0) {
            enlarged_avg_lt = enlarged_count[left[i]]/digit_image_count[left[i]] + 0.4;
            if (enlarged_avg_lt <= 1) {
                printf ", %.0f enlarged loop", enlarged_avg_lt;
            } else {
                printf ", %.0f enlarged loops", enlarged_avg_lt;
            }
        }
        if (hemorrhage_count[left[i]] > 0) {
            hemorrhage_avg_lt = hemorrhage_count[left[i]]/digit_image_count[left[i]] + 0.4;
            if (hemorrhage_avg_lt <= 1) {
                printf ", %.0f hemorrhage", hemorrhage_avg_lt;
            } else {
                printf ", %.0f hemorrhages", hemorrhage_avg_lt;
            }
        }
        if (ramification_count[left[i]] > 0) {
            ramification_avg_lt = ramification_count[left[i]]/digit_image_count[left[i]] + 0.4;
            if (ramification_avg_lt <= 1) {
                printf ", %.0f ramification", ramification_avg_lt;
            } else {
                printf ", %.0f ramifications", ramification_avg_lt;
            }
        }
        if (disorganization_count[left[i]] > 0) {
            disorganization_avg_lt = disorganization_count[left[i]]/digit_image_count[left[i]] + 0.4;
            if (disorganization_avg_lt <= 1) {
                printf ", %.0f disorganized loop", disorganization_avg_lt;
            } else {
                printf ", %.0f disorganized loops", disorganization_avg_lt;
            }
        }
        printf "\r\n";
    }

    printf "Other findings:\r\n";

    printf "  Capillary density: average " total_capillary_count/images_with_capillaries " capillaries/mm,";
    if (total_capillary_count/images_with_capillaries >= 7) {printf " not";}
    printf " decreased\r\n";

    printf "  Capillary diameter > 50uM (giant capillary): %s\r\n", giants;
    printf "  Hemorrhage: "
    if (length(hemorrhage) > 0) {
        printf "yes, in ";
        for (i=1; i <= length(hemorrhage); i++) {
            printf "%s", hemorrhage[i];
            if (i == length(hemorrhage)) {
                printf "\r\n";
                break;
            }
            printf ", ";
        }
    }
    else {
        printf "no\r\n";
    }
    printf "Impression:";
    printf "  [ Non-scleroderma | Scleroderma ] pattern\r\n";
    printf "Non-specific abnormalities:\r\n";
    if (length(hemorrhage) > 0) {
        printf "  - hemorrhage\r\n";
    }
    printf "  [ - focal avascular area ]\r\n";
    if (length(enlarged) > 0) {
        printf "  - ectasic capillaries (<50uM) in ";
        for (i=1; i <= length(enlarged); i++) {
            printf "%s", enlarged[i];
            if (i == length(enlarged)) {
                printf "\r\n";
                break;
            }
            printf ", ";
        }
    }
    printf "\r\n";
}