import requests
from bs4 import BeautifulSoup
import re

def get_latest_download_link(url):
    try:
        # Fetch the HTML content from the URL
        response = requests.get(url)
        response.raise_for_status()

        # Parse the HTML content
        soup = BeautifulSoup(response.text, 'html.parser')

        # Define the pattern to search for
        pattern = re.compile(r'getfile\.php\?name=ShellyScan_.*?_sj\.jar')

        # Find the first download link that matches the pattern
        download_link = soup.find('a', href=pattern)
        if download_link:
            return url[:url.rfind('/')] + "/" + download_link['href']
        else:
            return "No download link found in the specified format."

    except requests.RequestException as e:
        return f"An error occurred: {e}"

# URL of the page to scrape
url = 'https://www.usna.it/shellyscanner/download_en.php'

# Get the latest download link
latest_download_link = get_latest_download_link(url)
print(latest_download_link)
