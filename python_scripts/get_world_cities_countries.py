import geonamescache
import csv
from unidecode import unidecode

def generate_city_csv(limit=50000, output_filename='biggest_cities.csv'):
    gc = geonamescache.GeonamesCache()

    # Fetch cities and countries data
    cities = gc.get_cities()
    countries = gc.get_countries()

    # Convert the cities dictionary to a list and include all cities
    city_list = [
        {
            'city_name_original': city_data['name'].lower(),
            'city_name_latin': unidecode(city_data['name']).lower() if 'ascii' not in city_data else city_data['ascii'].lower(),
            'country_code': city_data['countrycode'].lower(),
            'population': city_data.get('population', 0)  # Default to 0 if population is missing
        }
        for city_id, city_data in cities.items()
    ]

    # Sort cities by population in descending order
    sorted_cities = sorted(city_list, key=lambda c: c['population'], reverse=True)

    # Limit to the top 'limit' cities
    top_cities = sorted_cities[:limit]

    # Write to CSV file
    with open(output_filename, mode='w', newline='', encoding='utf-8') as file:
        writer = csv.writer(file)
        # Include 'population' in the header row
        writer.writerow(['city_name_original', 'city_name_latin', 'country_name', 'country_code', 'population'])

        for city in top_cities:
            # Correctly retrieve the country name using the country code
            country_name = countries.get(city['country_code'].upper(), {}).get('name', 'unknown').lower()
            # Write the city data including population to the CSV
            writer.writerow([city['city_name_original'], city['city_name_latin'], country_name, city['country_code'], city['population']])

if __name__ == "__main__":
    generate_city_csv()
    print("CSV file 'world_cities_countries.csv' generated successfully.")
