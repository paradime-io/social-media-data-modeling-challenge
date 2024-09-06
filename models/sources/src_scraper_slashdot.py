import requests
from bs4 import BeautifulSoup
import pandas as pd

class WebScraper:
    def __init__(self, base_url, total_pages):
        self.base_url = base_url
        self.total_pages = total_pages
        self.data = []
        self.id_counter = 1

    def get_page(self, url):
        try:
            response = requests.get(url)
            response.raise_for_status()
            return response.content
        except requests.exceptions.RequestException as e:
            print(f"Failed to fetch {url}: {e}")
            return None

    def extract_links(self, page_content):
        soup = BeautifulSoup(page_content, "html.parser")
        section = soup.find('div', class_='grid_24')
        if not section:
            return []

        # Extract articles links from 'a' each page
        links = ['https:' + a['href'] for a in section.find_all('a', href=True) if "slashdot.org/story" in a['href']]
        return links

    def extract_content(self, url):
        page_content = self.get_page(url)
        if not page_content:
            return None

        soup = BeautifulSoup(page_content, "html.parser")

        # Extract title from span with class 'story-title'
        title_tag = soup.find('span', class_='story-title')
        title = title_tag.get_text().strip() if title_tag else None

        # Extract content from all divs with class 'p'
        article_content = ' '.join([div.get_text() for div in soup.find_all('div', class_='p')])

        # Extract author information from span with class 'story-byline'
        author_info = soup.find('span', class_='story-byline')
        if author_info:
            # Extract datetime from the 'time' tag inside the span
            time_tag = author_info.find('time')
            publication_date = time_tag.get('datetime') if time_tag else None
            
            # Extract author name
            author = None
            author_a_tag = author_info.find('a')
            if author_a_tag:
                author = author_a_tag.get_text().strip()
            else:
                # If not in 'a' tag, get the text directly from the span
                author = author_info.get_text(separator='|').split('|')[0].strip()
        else:
            author = None
            publication_date = None

        # Extract number of comments from element with class 'comment-bubble'
        comment_bubble = soup.find(class_='comment-bubble')
        comments = comment_bubble.get_text().strip() if comment_bubble else '0'

        data = {
            'id': self.id_counter,
            'url': url,
            'title': title,
            'content': article_content,
            'author': author,
            'publication_date': publication_date,
            'comments': comments
        }

        self.id_counter += 1
        return data

    def save_to_dataframe(self, data):
        self.data.append(data)

    def run(self):
        for page_num in range(1, self.total_pages + 1):
            page_url = f"{self.base_url}{page_num}"
            print(f"Scraping page {page_num}: {page_url}")
            page_content = self.get_page(page_url)
            
            if not page_content:
                continue

            links = self.extract_links(page_content)
            for link in links:
                print(f"Scraping article from {link}")
                article_data = self.extract_content(link)
                if article_data:
                    self.save_to_dataframe(article_data)

    def get_dataframe(self):
        return pd.DataFrame(self.data)

# DBT model function
def model(dbt, session):
    base_url = "https://slashdot.org/archive.pl?op=bytime&keyword=&year=2022&page="
    total_pages = 29

    scraper = WebScraper(base_url, total_pages)
    scraper.run()

    # Return the final DataFrame
    return scraper.get_dataframe()
