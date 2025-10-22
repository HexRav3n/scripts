#!/usr/bin/env python3

import argparse
import requests

GREEN = '\033[92m'
RED = '\033[91m'
RESET = '\033[0m'

def colorize_status(status_code):
    if status_code in [200, 201, 202, 204, 400, 500, 501, 502, 503]:
        return f"{GREEN}{status_code}{RESET}"
    else:
        return f"{RED}{status_code}{RESET}"

parser = argparse.ArgumentParser()
parser.add_argument('-t','--target', help='host/ip to target', required=True)
parser.add_argument('-w','--wordlist', help='wordlist to use')
args = parser.parse_args()

actions = []

s = requests.Session()



with open(args.wordlist, "r") as f:
    for word in f:
            status_msg = word.strip()[:80]
            print('\r' + ' '*100 + '\r' + status_msg, end='', flush=True)

            url = "{target}{word}".format(target=args.target, word=word.strip())

            r_get = s.get(url=url).status_code
            r_post = s.post(url=url).status_code
            r_put = s.put(url=url).status_code
            r_patch = s.patch(url=url).status_code
            r_options = s.options(url=url).status_code
            r_head = s.head(url=url).status_code

            if(r_get not in [204,401,403,404] or r_post not in [204,401,403,404] or r_put not in [204,401,403,404] or r_patch not in [204,401,403,404] or r_options not in [204,401,403,404] or r_head not in [204,401,403,404]):
                print('\r' + ' '*100 + '\r', end='')

                if not actions:
                    print("+" + "-"*50 + "+" + "-"*6 + "+" + "-"*6 + "+" + "-"*6 + "+" + "-"*7 + "+" + "-"*9 + "+" + "-"*6 + "+")
                    print("| {:<48} | {:<4} | {:<4} | {:<4} | {:<5} | {:<7} | {:<4} |".format("Path", "GET", "POST", "PUT", "PATCH", "OPTIONS", "HEAD"))
                    print("+" + "-"*50 + "+" + "-"*6 + "+" + "-"*6 + "+" + "-"*6 + "+" + "-"*7 + "+" + "-"*9 + "+" + "-"*6 + "+")

                path_display = word.strip()[:48]

                print("| {:<48} | {} | {} | {} | {} | {} | {} |".format(
                    path_display,
                    colorize_status(r_get).ljust(4 + len(GREEN) + len(RESET)),
                    colorize_status(r_post).ljust(4 + len(GREEN) + len(RESET)),
                    colorize_status(r_put).ljust(4 + len(GREEN) + len(RESET)),
                    colorize_status(r_patch).ljust(5 + len(GREEN) + len(RESET)),
                    colorize_status(r_options).ljust(7 + len(GREEN) + len(RESET)),
                    colorize_status(r_head).ljust(4 + len(GREEN) + len(RESET))
                ))
                actions.append(word.strip())

print('\r' + ' '*100 + '\r', end='')

if actions:
    print("+" + "-"*50 + "+" + "-"*6 + "+" + "-"*6 + "+" + "-"*6 + "+" + "-"*7 + "+" + "-"*9 + "+" + "-"*6 + "+")

print("Wordlist complete. Goodbye.")
