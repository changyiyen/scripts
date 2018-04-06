#!/usr/bin/gawk -f
# only known to work on gawk (uses asort)
BEGIN {
	FS = ",";
	if (ARGC != 3) {
		print "usage: lotterycheck.awk selected_num.csv win_num.csv";
		exit 1;
	}
}
FILENAME == ARGV[1] {
	split($0, selected);
	if (length(selected) != 6) {
		print "Error on input file", ARGV[1], "line", FNR;
		exit 2;
	}
	asort(selected);
	for (i = 1; i <= 6; i++) {
		selected_all[FNR, i] = selected[i];
	}
	s=FNR;
}
FILENAME == ARGV[2] {
	split($0, numbers);
	if (length(numbers) != 6) {
		print "Error on input file", ARGV[2], "line", FNR;
		exit 3;
	}
	asort(numbers);
	for (i = 1; i <= 6; i++) {
		numbers_all[FNR, i] = numbers[i];
	}
	n=FNR;
}
END {
	for(i = 1; i <= s; i++) {
		for (j = 1; j <= n; j++) {
			for (k = 1; k <= 6; k++) {
				if (selected_all[i,k] == numbers_all[j,k]) {
					m[i,j]++;
					#print m[i,j], i, j;
				}
			}
		}
	}
	for(i = 1; i <= s; i++) {
		for (j = 1; j <= n; j++) {
			if (i SUBSEP j in m) {
				print "Number set", i, "has", m[i,j], "match(es) at", j;
			}
		}
	}
}
