import csv
import sys


def main():
#new dna file.
    # TODO: Check for command-line usage
    if len(sys.argv) != 3:
        sys.exit("incorrect number of inputs")

    # TODO: Read database file into a variable

    with open(sys.argv[1]) as csv.file:
        reader = csv.DictReader(csv.file)
        database =[]
        for row in reader:
            database.append(row)

     # TODO: Read DNA sequence file into a variable
    with open(sys.argv[2]) as dna_sequence:
        sequence = dna_sequence.read()


    # TODO: Find longest match of each STR in DNA sequence
        match_found = {}
        for key in database[0].keys():
            if key == "name":
                continue
        #use longest match from the def file
            match_found[key] = longest_match(sequence,key)

    # TODO: Check database for matching profiles
        # STR
        #loop each row in the database
        for row in database:
            match = True
            # loop through each key
            for key in row.keys():
                if key=="name":
                    continue
                #if no match, keep the loop
                if int(row[key]) != match_found[key]:
                    match = False
                    break
            #if match fund, print the name
            if match:
                print(row["name"])
                return
        #if no match is found, print no match
        print("no match")


def longest_match(sequence, subsequence):
    """Returns length of longest run of subsequence in sequence."""

    # Initialize variables
    longest_run = 0
    subsequence_length = len(subsequence)
    sequence_length = len(sequence)

    # Check each character in sequence for most consecutive runs of subsequence
    for i in range(sequence_length):

        # Initialize count of consecutive runs
        count = 0

        # Check for a subsequence match in a "substring" (a subset of characters) within sequence
        # If a match, move substring to next potential match in sequence
        # Continue moving substring and checking for matches until out of consecutive matches
        while True:

            # Adjust substring start and end
            start = i + count * subsequence_length
            end = start + subsequence_length

            # If there is a match in the substring
            if sequence[start:end] == subsequence:
                count += 1

            # If there is no match in the substring
            else:
                break

        # Update most consecutive matches found
        longest_run = max(longest_run, count)

    # After checking for runs at each character in seqeuence, return longest run found
    return longest_run


main()
