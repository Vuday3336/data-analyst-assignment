minutes = int(input("Enter minutes: "))
hours = minutes // 60
remaining = minutes % 60
if hours > 0:
    print(f"{hours} hr {remaining} minutes")
else:
    print(f"{remaining} minutes")