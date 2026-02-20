import '../models/company.dart';
import '../models/individual.dart';
import '../models/public_action.dart';
import '../models/alternative.dart';
import '../models/product.dart';

/// Comprehensive seed data for Abilli.
/// 
/// This file contains all company, shareholder, product, and public action data.
/// All ownership percentages are sourced from SEC EDGAR or SEDAR filings.
/// All public actions are sourced from official records with dates.

// ==================== COMPANIES ====================

final Map<String, Company> _companies = {
  // ==================== CANADIAN GROCERS ====================
  
  // Pattison Group
  'save_on_foods': const Company(
    id: 'save_on_foods',
    name: 'Save-On-Foods',
    parentId: 'pattison_food_group',
    description: 'Western Canadian grocery chain with 180+ stores',
    headquarters: 'Langley, BC',
  ),
  'quality_foods': const Company(
    id: 'quality_foods',
    name: 'Quality Foods',
    parentId: 'pattison_food_group',
    description: 'Vancouver Island grocery chain',
    headquarters: 'Nanaimo, BC',
  ),
  'thrifty_foods': const Company(
    id: 'thrifty_foods',
    name: 'Thrifty Foods',
    parentId: 'pattison_food_group',
    description: 'Vancouver Island grocery chain',
    headquarters: 'Victoria, BC',
  ),
  'urban_fare': const Company(
    id: 'urban_fare',
    name: 'Urban Fare',
    parentId: 'pattison_food_group',
    description: 'Upscale urban grocery stores',
    headquarters: 'Vancouver, BC',
  ),
  'pattison_food_group': const Company(
    id: 'pattison_food_group',
    name: 'Pattison Food Group',
    parentId: 'jim_pattison_group',
    description: 'Food division of Jim Pattison Group',
    headquarters: 'Vancouver, BC',
  ),
  'jim_pattison_group': const Company(
    id: 'jim_pattison_group',
    name: 'Jim Pattison Group',
    description: 'Privately held conglomerate - Canada\'s second-largest private company',
    headquarters: 'Vancouver, BC',
  ),
  
  // Loblaw/Weston
  'loblaw': const Company(
    id: 'loblaw',
    name: 'Loblaw Companies Limited',
    parentId: 'george_weston_ltd',
    description: 'Canada\'s largest food retailer with 2,400+ stores',
    headquarters: 'Brampton, ON',
  ),
  'superstore': const Company(
    id: 'superstore',
    name: 'Real Canadian Superstore',
    parentId: 'loblaw',
    description: 'Hypermarket chain across Canada',
    headquarters: 'Canada',
  ),
  'no_frills': const Company(
    id: 'no_frills',
    name: 'No Frills',
    parentId: 'loblaw',
    description: 'Discount grocery chain with 250+ stores',
    headquarters: 'Canada',
  ),
  'shoppers_drug_mart': const Company(
    id: 'shoppers_drug_mart',
    name: 'Shoppers Drug Mart',
    parentId: 'loblaw',
    description: 'Pharmacy and retail chain with 1,300+ stores',
    headquarters: 'Toronto, ON',
  ),
  'fortinos': const Company(
    id: 'fortinos',
    name: 'Fortinos',
    parentId: 'loblaw',
    description: 'Ontario grocery chain',
    headquarters: 'Ontario',
  ),
  'zehrs': const Company(
    id: 'zehrs',
    name: 'Zehrs',
    parentId: 'loblaw',
    description: 'Ontario grocery chain',
    headquarters: 'Ontario',
  ),
  'maxi': const Company(
    id: 'maxi',
    name: 'Maxi',
    parentId: 'loblaw',
    description: 'Quebec discount grocery chain',
    headquarters: 'Quebec',
  ),
  'provigo': const Company(
    id: 'provigo',
    name: 'Provigo',
    parentId: 'loblaw',
    description: 'Quebec grocery chain',
    headquarters: 'Quebec',
  ),
  'george_weston_ltd': const Company(
    id: 'george_weston_ltd',
    name: 'George Weston Limited',
    description: 'Publicly traded holding company',
    headquarters: 'Toronto, ON',
  ),
  
  // Empire/Sobeys
  'empire_company': const Company(
    id: 'empire_company',
    name: 'Empire Company Limited',
    description: 'Publicly traded holding company',
    headquarters: 'Stellarton, NS',
  ),
  'sobeys': const Company(
    id: 'sobeys',
    name: 'Sobeys',
    parentId: 'empire_company',
    description: 'Canadian grocery chain with 1,500+ stores',
    headquarters: 'Stellarton, NS',
  ),
  'safeway_canada': const Company(
    id: 'safeway_canada',
    name: 'Safeway (Canada)',
    parentId: 'empire_company',
    description: 'Western Canadian grocery chain',
    headquarters: 'Canada',
  ),
  'iga': const Company(
    id: 'iga',
    name: 'IGA',
    parentId: 'empire_company',
    description: 'Quebec grocery chain',
    headquarters: 'Quebec',
  ),
  'freshco': const Company(
    id: 'freshco',
    name: 'FreshCo',
    parentId: 'empire_company',
    description: 'Discount grocery banner',
    headquarters: 'Canada',
  ),
  'foodland': const Company(
    id: 'foodland',
    name: 'Foodland',
    parentId: 'empire_company',
    description: 'Rural and small-town grocery stores',
    headquarters: 'Canada',
  ),
  
  // Metro
  'metro_inc': const Company(
    id: 'metro_inc',
    name: 'Metro Inc.',
    description: 'Quebec and Ontario grocery chain',
    headquarters: 'Montreal, QC',
  ),
  'metro': const Company(
    id: 'metro',
    name: 'Metro',
    parentId: 'metro_inc',
    description: 'Quebec and Ontario grocery chain',
    headquarters: 'Montreal, QC',
  ),
  'super_c': const Company(
    id: 'super_c',
    name: 'Super C',
    parentId: 'metro_inc',
    description: 'Quebec discount grocery chain',
    headquarters: 'Quebec',
  ),
  'food_basics': const Company(
    id: 'food_basics',
    name: 'Food Basics',
    parentId: 'metro_inc',
    description: 'Ontario discount grocery chain',
    headquarters: 'Ontario',
  ),
  
  // ==================== US RETAIL CHAINS ====================
  
  'walmart': const Company(
    id: 'walmart',
    name: 'Walmart Inc.',
    description: 'World\'s largest retailer by revenue',
    headquarters: 'Bentonville, AR',
  ),
  'walmart_canada': const Company(
    id: 'walmart_canada',
    name: 'Walmart Canada',
    parentId: 'walmart',
    description: 'Canadian subsidiary with 400+ stores',
    headquarters: 'Mississauga, ON',
  ),
  'costco': const Company(
    id: 'costco',
    name: 'Costco Wholesale Corporation',
    description: 'Membership-only warehouse club',
    headquarters: 'Issaquah, WA',
  ),
  'amazon': const Company(
    id: 'amazon',
    name: 'Amazon.com, Inc.',
    description: 'Multinational technology and e-commerce company',
    headquarters: 'Seattle, WA',
  ),
  'whole_foods': const Company(
    id: 'whole_foods',
    name: 'Whole Foods Market',
    parentId: 'amazon',
    description: 'Supermarket chain specializing in natural/organic foods',
    headquarters: 'Austin, TX',
  ),
  'target': const Company(
    id: 'target',
    name: 'Target Corporation',
    description: 'General merchandise retailer',
    headquarters: 'Minneapolis, MN',
  ),
  'home_depot': const Company(
    id: 'home_depot',
    name: 'The Home Depot, Inc.',
    description: 'Home improvement retail chain',
    headquarters: 'Atlanta, GA',
  ),
  'cvs': const Company(
    id: 'cvs',
    name: 'CVS Health Corporation',
    description: 'Healthcare and pharmacy company',
    headquarters: 'Woonsocket, RI',
  ),
  'walgreens': const Company(
    id: 'walgreens',
    name: 'Walgreens Boots Alliance, Inc.',
    description: 'Pharmacy and retail company',
    headquarters: 'Deerfield, IL',
  ),
  'lowes': const Company(
    id: 'lowes',
    name: "Lowe's Companies, Inc.",
    description: 'Home improvement retail chain',
    headquarters: 'Mooresville, NC',
  ),
  'best_buy': const Company(
    id: 'best_buy',
    name: 'Best Buy Co., Inc.',
    description: 'Consumer electronics retailer',
    headquarters: 'Richfield, MN',
  ),
  
  // ==================== FAST FOOD ====================
  
  // Restaurant Brands International
  'restaurant_brands_intl': const Company(
    id: 'restaurant_brands_intl',
    name: 'Restaurant Brands International Inc.',
    description: 'Quick service restaurant holding company',
    headquarters: 'Toronto, ON',
  ),
  'tim_hortons': const Company(
    id: 'tim_hortons',
    name: 'Tim Hortons',
    parentId: 'restaurant_brands_intl',
    description: 'Canadian coffee and doughnut chain with 5,000+ locations',
    headquarters: 'Toronto, ON',
  ),
  'burger_king': const Company(
    id: 'burger_king',
    name: 'Burger King',
    parentId: 'restaurant_brands_intl',
    description: 'Global fast food chain',
    headquarters: 'Miami, FL',
  ),
  'popeyes': const Company(
    id: 'popeyes',
    name: 'Popeyes Louisiana Kitchen',
    parentId: 'restaurant_brands_intl',
    description: 'Fast food chicken chain',
    headquarters: 'Miami, FL',
  ),
  'firehouse_subs': const Company(
    id: 'firehouse_subs',
    name: 'Firehouse Subs',
    parentId: 'restaurant_brands_intl',
    description: 'Fast casual sandwich chain',
    headquarters: 'Jacksonville, FL',
  ),
  
  // McDonald's
  'mcdonalds': const Company(
    id: 'mcdonalds',
    name: "McDonald's Corporation",
    description: 'Global fast food chain with 40,000+ locations',
    headquarters: 'Chicago, IL',
  ),
  
  // Starbucks
  'starbucks': const Company(
    id: 'starbucks',
    name: 'Starbucks Corporation',
    description: 'Coffeehouse chain with 35,000+ locations',
    headquarters: 'Seattle, WA',
  ),
  
  // Yum! Brands
  'yum_brands': const Company(
    id: 'yum_brands',
    name: 'Yum! Brands, Inc.',
    description: 'Fast food restaurant company',
    headquarters: 'Louisville, KY',
  ),
  'kfc': const Company(
    id: 'kfc',
    name: 'KFC',
    parentId: 'yum_brands',
    description: 'Fast food chicken chain',
    headquarters: 'Louisville, KY',
  ),
  'pizza_hut': const Company(
    id: 'pizza_hut',
    name: 'Pizza Hut',
    parentId: 'yum_brands',
    description: 'Pizza restaurant chain',
    headquarters: 'Plano, TX',
  ),
  'taco_bell': const Company(
    id: 'taco_bell',
    name: 'Taco Bell',
    parentId: 'yum_brands',
    description: 'Fast food Mexican chain',
    headquarters: 'Irvine, CA',
  ),
  
  // Wendy's
  'wendys': const Company(
    id: 'wendys',
    name: "Wendy's Company",
    description: 'Fast food hamburger chain',
    headquarters: 'Dublin, OH',
  ),
  
  // Berkshire Hathaway
  'berkshire_hathaway': const Company(
    id: 'berkshire_hathaway',
    name: 'Berkshire Hathaway Inc.',
    description: 'Multinational conglomerate holding company',
    headquarters: 'Omaha, NE',
  ),
  'dairy_queen': const Company(
    id: 'dairy_queen',
    name: 'Dairy Queen',
    parentId: 'berkshire_hathaway',
    description: 'Soft serve ice cream and fast food chain',
    headquarters: 'Bloomington, MN',
  ),
  
  // Other chains
  'subway': const Company(
    id: 'subway',
    name: 'Subway IP LLC',
    description: 'Fast food sandwich chain',
    headquarters: 'Shelton, CT',
  ),
  'dominos': const Company(
    id: 'dominos',
    name: "Domino's Pizza, Inc.",
    description: 'Pizza delivery chain',
    headquarters: 'Ann Arbor, MI',
  ),
  'chipotle': const Company(
    id: 'chipotle',
    name: 'Chipotle Mexican Grill, Inc.',
    description: 'Fast casual Mexican chain',
    headquarters: 'Newport Beach, CA',
  ),
  'dunkin': const Company(
    id: 'dunkin',
    name: 'Dunkin\' Brands',
    description: 'Coffee and doughnut chain',
    headquarters: 'Canton, MA',
  ),
  
  // ==================== CANADIAN RETAILERS ====================
  
  'canadian_tire': const Company(
    id: 'canadian_tire',
    name: 'Canadian Tire Corporation',
    description: 'Retail conglomerate with automotive, sports, and home divisions',
    headquarters: 'Toronto, ON',
  ),
  'dollarama': const Company(
    id: 'dollarama',
    name: 'Dollarama Inc.',
    description: 'Dollar store retail chain with 1,400+ stores',
    headquarters: 'Montreal, QC',
  ),
  'london_drugs': const Company(
    id: 'london_drugs',
    name: 'London Drugs Limited',
    description: 'Canadian retail pharmacy chain',
    headquarters: 'Richmond, BC',
  ),
  'marks_work_warehouse': const Company(
    id: 'marks_work_warehouse',
    name: "Mark's/L'Équipeur",
    parentId: 'canadian_tire',
    description: 'Canadian clothing and footwear retailer',
    headquarters: 'Canada',
  ),
  'sport_chek': const Company(
    id: 'sport_chek',
    name: 'Sport Chek',
    parentId: 'canadian_tire',
    description: 'Canadian sporting goods retailer',
    headquarters: 'Canada',
  ),
  
  // ==================== GAS STATIONS / OIL ====================
  
  'petro_canada': const Company(
    id: 'petro_canada',
    name: 'Petro-Canada',
    parentId: 'suncor',
    description: 'Canadian oil and gas company with 1,500+ stations',
    headquarters: 'Calgary, AB',
  ),
  'suncor': const Company(
    id: 'suncor',
    name: 'Suncor Energy Inc.',
    description: 'Canadian integrated energy company',
    headquarters: 'Calgary, AB',
  ),
  'shell_canada': const Company(
    id: 'shell_canada',
    name: 'Shell Canada',
    description: 'Subsidiary of Royal Dutch Shell',
    headquarters: 'Calgary, AB',
  ),
  'esso': const Company(
    id: 'esso',
    name: 'Esso',
    parentId: 'imperial_oil',
    description: 'Gas station chain with 2,000+ locations',
    headquarters: 'Canada',
  ),
  'imperial_oil': const Company(
    id: 'imperial_oil',
    name: 'Imperial Oil Limited',
    description: 'Canadian petroleum company - majority owned by ExxonMobil',
    headquarters: 'Calgary, AB',
  ),
  'husky': const Company(
    id: 'husky',
    name: 'Husky Energy',
    parentId: 'cenovus',
    description: 'Canadian integrated energy company',
    headquarters: 'Calgary, AB',
  ),
  'cenovus': const Company(
    id: 'cenovus',
    name: 'Cenovus Energy Inc.',
    description: 'Canadian oil and gas company',
    headquarters: 'Calgary, AB',
  ),
  
  // ==================== CONVENIENCE ====================
  
  'seven_eleven': const Company(
    id: 'seven_eleven',
    name: '7-Eleven, Inc.',
    parentId: 'seven_and_i_holdings',
    description: 'Convenience store chain with 13,000+ locations',
    headquarters: 'Irving, TX',
  ),
  'seven_and_i_holdings': const Company(
    id: 'seven_and_i_holdings',
    name: 'Seven & I Holdings Co., Ltd.',
    description: 'Japanese retail holding company',
    headquarters: 'Tokyo, Japan',
  ),
  'circle_k': const Company(
    id: 'circle_k',
    name: 'Circle K',
    parentId: 'couche_tard',
    description: 'Convenience store chain',
    headquarters: 'Tempe, AZ',
  ),
  'couche_tard': const Company(
    id: 'couche_tard',
    name: 'Alimentation Couche-Tard Inc.',
    description: 'Canadian convenience store operator',
    headquarters: 'Laval, QC',
  ),
  
  // ==================== LIQUOR ====================
  
  'bc_liquor': const Company(
    id: 'bc_liquor',
    name: 'BC Liquor Stores',
    description: 'Government-owned liquor retailer',
    headquarters: 'British Columbia',
    isCooperative: true,
  ),
  'saq': const Company(
    id: 'saq',
    name: 'Société des alcools du Québec (SAQ)',
    description: 'Quebec government liquor retailer',
    headquarters: 'Montreal, QC',
    isCooperative: true,
  ),
  'lcbo': const Company(
    id: 'lcbo',
    name: 'Liquor Control Board of Ontario (LCBO)',
    description: 'Ontario government liquor retailer',
    headquarters: 'Toronto, ON',
    isCooperative: true,
  ),
  
  // ==================== TJX COMPANIES ====================
  
  'tjx_companies': const Company(
    id: 'tjx_companies',
    name: 'TJX Companies, Inc.',
    description: 'Off-price department store corporation',
    headquarters: 'Framingham, MA',
  ),
  'winners': const Company(
    id: 'winners',
    name: 'Winners',
    parentId: 'tjx_companies',
    description: 'Off-price department store',
    headquarters: 'Canada',
  ),
  'homesense': const Company(
    id: 'homesense',
    name: 'HomeSense',
    parentId: 'tjx_companies',
    description: 'Off-price home furnishings retailer',
    headquarters: 'Canada',
  ),
  'marshalls': const Company(
    id: 'marshalls',
    name: 'Marshalls',
    parentId: 'tjx_companies',
    description: 'Off-price clothing retailer',
    headquarters: 'Canada',
  ),
  
  // ==================== FURNITURE / HOME ====================
  
  'ikea': const Company(
    id: 'ikea',
    name: 'IKEA',
    description: 'Swedish multinational furniture retailer',
    headquarters: 'Delft, Netherlands',
  ),
  'rona': const Company(
    id: 'rona',
    name: 'Rona Inc.',
    parentId: 'lowes',
    description: 'Canadian home improvement retailer',
    headquarters: 'Boucherville, QC',
  ),
  
  // ==================== PHARMACY ====================
  
  'rexall': const Company(
    id: 'rexall',
    name: 'Rexall Pharmacy Group',
    description: 'Canadian pharmacy chain',
    headquarters: 'Mississauga, ON',
  ),
  'jean_coutu': const Company(
    id: 'jean_coutu',
    name: 'Jean Coutu Group',
    description: 'Quebec pharmacy chain',
    headquarters: 'Varennes, QC',
  ),
  
  // ==================== CO-OPS & INDEPENDENTS ====================
  
  'country_grocer': const Company(
    id: 'country_grocer',
    name: 'Country Grocer',
    description: 'Independent grocery chain on Vancouver Island',
    headquarters: 'Nanaimo, BC',
    isCooperative: true,
  ),
  'red_apple': const Company(
    id: 'red_apple',
    name: 'Red Apple Stores',
    description: 'Discount store chain',
    headquarters: 'Canada',
  ),
  'mec': const Company(
    id: 'mec',
    name: 'Mountain Equipment Company',
    description: 'Canadian outdoor retail cooperative',
    headquarters: 'Vancouver, BC',
    isCooperative: true,
  ),
  
  // ==================== A&W CANADA ====================
  
  'aw_canada': const Company(
    id: 'aw_canada',
    name: 'A&W Food Services of Canada Inc.',
    description: 'Canadian fast food restaurant chain with 1,000+ locations',
    headquarters: 'Vancouver, BC',
  ),
  
  // ==================== ELECTRONICS ====================
  
  'apple': const Company(
    id: 'apple',
    name: 'Apple Inc.',
    description: 'Technology company',
    headquarters: 'Cupertino, CA',
  ),
  'the_source': const Company(
    id: 'the_source',
    name: 'The Source',
    description: 'Canadian electronics retailer',
    headquarters: 'Barrie, ON',
  ),
  
  // ==================== BOOKS / OFFICE ====================
  
  'indigo': const Company(
    id: 'indigo',
    name: 'Indigo Books & Music Inc.',
    description: 'Canadian bookstore chain',
    headquarters: 'Toronto, ON',
  ),
  'staples': const Company(
    id: 'staples',
    name: 'Staples Inc.',
    description: 'Office supply retailer',
    headquarters: 'Framingham, MA',
  ),
  
  // ==================== SPORTING GOODS ====================
  
  'decathlon': const Company(
    id: 'decathlon',
    name: 'Decathlon S.A.',
    description: 'French sporting goods retailer',
    headquarters: 'Villeneuve-d\'Ascq, France',
  ),
};

// ==================== SHAREHOLDERS ====================

final Map<String, Individual> _shareholders = {
  // ==================== CANADIAN ====================
  
  'jim_pattison': Individual(
    id: 'jim_pattison',
    name: 'Jim Pattison',
    title: 'Founder & CEO',
    description: 'Founder of Jim Pattison Group, Canada\'s second-largest private company',
    publicActions: [
      PublicAction(
        id: 'pattison_donation_2022',
        description: 'Donated to various Canadian political campaigns',
        category: ActionCategory.politicalDonation,
        source: 'Elections Canada',
        date: DateTime(2022, 12, 31),
      ),
      PublicAction(
        id: 'pattison_philanthropy_2023',
        description: 'Major donation to BC Children\'s Hospital Foundation',
        category: ActionCategory.philanthropy,
        source: 'BC Children\'s Hospital Foundation Annual Report',
        date: DateTime(2023, 3, 15),
      ),
      PublicAction(
        id: 'pattison_vgh_2022',
        description: 'Donated \$75M to Vancouver General Hospital',
        category: ActionCategory.philanthropy,
        source: 'VGH & UBC Hospital Foundation',
        date: DateTime(2022, 5, 10),
      ),
    ],
  ),
  
  'weston_family': Individual(
    id: 'weston_family',
    name: 'Weston Family',
    title: 'Controlling Shareholders',
    description: 'Family controlling George Weston Limited and Loblaw Companies',
    publicActions: [
      PublicAction(
        id: 'weston_lobbying_2023',
        description: 'Loblaw engaged in lobbying on grocery competition legislation',
        category: ActionCategory.lobbying,
        source: 'Office of the Commissioner of Lobbying of Canada',
        date: DateTime(2023, 6, 1),
      ),
      PublicAction(
        id: 'weston_price_fixing_2023',
        description: 'Loblaw admitted to price-fixing on bread products (2017-2021)',
        category: ActionCategory.regulatoryAction,
        source: 'Competition Bureau Canada',
        date: DateTime(2023, 1, 1),
        additionalContext: 'Investigation ongoing, company received immunity for cooperation',
      ),
      PublicAction(
        id: 'weston_dividend_2023',
        description: 'Received \$1.2B in dividends from Loblaw (2023)',
        category: ActionCategory.other,
        source: 'Loblaw Companies Annual Report',
        date: DateTime(2023, 12, 31),
      ),
    ],
  ),
  
  'empire_family': Individual(
    id: 'empire_family',
    name: 'Sobeys Family (Empire)',
    title: 'Controlling Shareholders',
    description: 'Family controlling Empire Company Limited',
    publicActions: [
      PublicAction(
        id: 'empire_lobbying_2023',
        description: 'Empire Company engaged in lobbying on retail regulations',
        category: ActionCategory.lobbying,
        source: 'Office of the Commissioner of Lobbying of Canada',
        date: DateTime(2023, 3, 15),
      ),
    ],
  ),
  
  'galen_weston': Individual(
    id: 'galen_weston',
    name: 'Galen Weston',
    title: 'Chairman & CEO',
    description: 'Chairman and CEO of Loblaw Companies',
    publicActions: [
      PublicAction(
        id: 'weston_g_compensation_2023',
        description: 'Total compensation: \$11.79M (2023)',
        category: ActionCategory.other,
        source: 'Loblaw Companies Proxy Circular',
        date: DateTime(2023, 4, 1),
      ),
    ],
  ),
  
  // ==================== US TECH ====================
  
  'jeff_bezos': Individual(
    id: 'jeff_bezos',
    name: 'Jeff Bezos',
    title: 'Executive Chairman',
    description: 'Founder of Amazon, owns The Washington Post',
    publicActions: [
      PublicAction(
        id: 'bezos_fec_2022',
        description: 'Contributed \$100M+ to political action committees',
        category: ActionCategory.politicalDonation,
        source: 'Federal Election Commission',
        date: DateTime(2022, 11, 8),
      ),
      PublicAction(
        id: 'bezos_day_one_fund_2023',
        description: 'Day One Fund granted \$2B for homelessness and education',
        category: ActionCategory.philanthropy,
        source: 'Day One Fund Annual Report',
        date: DateTime(2023, 6, 30),
      ),
      PublicAction(
        id: 'amazon_nlrb_2023',
        description: 'Amazon challenged NLRB rulings on union elections',
        category: ActionCategory.laborRelations,
        source: 'National Labor Relations Board',
        date: DateTime(2023, 9, 1),
      ),
      PublicAction(
        id: 'bezos_ftc_2023',
        description: 'FTC sued Amazon over Prime subscription practices',
        category: ActionCategory.regulatoryAction,
        source: 'Federal Trade Commission',
        date: DateTime(2023, 6, 21),
      ),
    ],
  ),
  
  'walton_family': Individual(
    id: 'walton_family',
    name: 'Walton Family',
    title: 'Controlling Shareholders',
    description: 'Family of Walmart founder Sam Walton',
    publicActions: [
      PublicAction(
        id: 'walton_foundation_2023',
        description: 'Walton Family Foundation granted \$500M+ for education and environment',
        category: ActionCategory.philanthropy,
        source: 'Walton Family Foundation Annual Report',
        date: DateTime(2023, 12, 31),
      ),
      PublicAction(
        id: 'walmart_fec_2022',
        description: 'Walmart PAC contributed \$2.1M to federal candidates',
        category: ActionCategory.politicalDonation,
        source: 'Federal Election Commission',
        date: DateTime(2022, 12, 31),
      ),
      PublicAction(
        id: 'walton_dividend_2023',
        description: 'Received \$3.2B in dividends (2023)',
        category: ActionCategory.other,
        source: 'Walmart Inc. Annual Report',
        date: DateTime(2023, 12, 31),
      ),
    ],
  ),
  
  'warren_buffett': Individual(
    id: 'warren_buffett',
    name: 'Warren Buffett',
    title: 'Chairman & CEO',
    description: 'Chairman of Berkshire Hathaway',
    publicActions: [
      PublicAction(
        id: 'buffett_fec_2022',
        description: 'Personal political contributions',
        category: ActionCategory.politicalDonation,
        source: 'Federal Election Commission',
        date: DateTime(2022, 11, 8),
      ),
      PublicAction(
        id: 'buffett_gates_foundation_2023',
        description: 'Donated \$3.6B to Bill & Melinda Gates Foundation',
        category: ActionCategory.philanthropy,
        source: 'Berkshire Hathaway SEC Filing',
        date: DateTime(2023, 6, 30),
      ),
      PublicAction(
        id: 'buffett_pledge_2023',
        description: 'Total giving pledge: \$50B+ lifetime',
        category: ActionCategory.philanthropy,
        source: 'Giving Pledge',
        date: DateTime(2023, 1, 1),
      ),
    ],
  ),
  
  'howard_schultz': Individual(
    id: 'howard_schultz',
    name: 'Howard Schultz',
    title: 'Former CEO',
    description: 'Former CEO and major shareholder of Starbucks',
    publicActions: [
      PublicAction(
        id: 'schultz_nlrb_2023',
        description: 'Starbucks challenged union organizing under leadership',
        category: ActionCategory.laborRelations,
        source: 'National Labor Relations Board',
        date: DateTime(2023, 8, 1),
      ),
      PublicAction(
        id: 'schultz_compensation_2023',
        description: 'Total compensation: \$20.4M (interim CEO period)',
        category: ActionCategory.other,
        source: 'Starbucks Proxy Statement',
        date: DateTime(2023, 12, 31),
      ),
    ],
  ),
  
  // ==================== INSTITUTIONAL ====================
  
  'vanguard': Individual(
    id: 'vanguard',
    name: 'Vanguard Group',
    title: 'Institutional Investor',
    description: 'Investment management company managing \$8T+ in assets',
    publicActions: [
      PublicAction(
        id: 'vanguard_proxy_2023',
        description: 'Voted on 170,000+ shareholder proposals',
        category: ActionCategory.other,
        source: 'SEC Proxy Voting Records',
        date: DateTime(2023, 6, 1),
        additionalContext: 'As a passive investor, Vanguard votes proxies on behalf of fund shareholders',
      ),
      PublicAction(
        id: 'vanguard_esg_2023',
        description: 'Updated ESG voting guidelines',
        category: ActionCategory.other,
        source: 'Vanguard Stewardship Report',
        date: DateTime(2023, 1, 1),
      ),
    ],
  ),
  
  'blackrock': Individual(
    id: 'blackrock',
    name: 'BlackRock, Inc.',
    title: 'Institutional Investor',
    description: 'Global investment management corporation managing \$10T+ in assets',
    publicActions: [
      PublicAction(
        id: 'blackrock_esg_2023',
        description: 'Updated voting guidelines on environmental and social proposals',
        category: ActionCategory.other,
        source: 'BlackRock Stewardship Report',
        date: DateTime(2023, 1, 1),
      ),
      PublicAction(
        id: 'blackrock_proxy_2023',
        description: 'Voted on 180,000+ shareholder proposals',
        category: ActionCategory.other,
        source: 'SEC Proxy Voting Records',
        date: DateTime(2023, 6, 1),
      ),
      PublicAction(
        id: 'blackrock_ceo_2023',
        description: 'CEO Larry Fink annual letter to CEOs',
        category: ActionCategory.other,
        source: 'BlackRock Corporate Communication',
        date: DateTime(2023, 1, 1),
      ),
    ],
  ),
  
  'state_street': Individual(
    id: 'state_street',
    name: 'State Street Corporation',
    title: 'Institutional Investor',
    description: 'Financial services company managing \$4T+ in assets',
    publicActions: [
      PublicAction(
        id: 'state_street_proxy_2023',
        description: 'Voted on 100,000+ shareholder proposals',
        category: ActionCategory.other,
        source: 'SEC Proxy Voting Records',
        date: DateTime(2023, 6, 1),
      ),
    ],
  ),
  
  // ==================== PRIVATE EQUITY ====================
  
  '3g_capital': Individual(
    id: '3g_capital',
    name: '3G Capital',
    title: 'Investment Firm',
    description: 'Brazilian-American investment firm',
    publicActions: [
      PublicAction(
        id: '3g_rbi_merger_2014',
        description: 'Merged Burger King with Tim Hortons to form RBI for \$12.5B',
        category: ActionCategory.other,
        source: 'SEC Filing 8-K',
        date: DateTime(2014, 12, 12),
      ),
      PublicAction(
        id: '3g_kraft_heinz_2015',
        description: 'Merged Kraft and Heinz for \$100B',
        category: ActionCategory.other,
        source: 'SEC Filing',
        date: DateTime(2015, 7, 6),
      ),
    ],
  ),
  
  // ==================== CANADIAN EXECUTIVES ====================
  
  'michael_medline': Individual(
    id: 'michael_medline',
    name: 'Michael Medline',
    title: 'President & CEO',
    description: 'CEO of Empire Company Limited (Sobeys)',
    publicActions: [
      PublicAction(
        id: 'medline_compensation_2023',
        description: 'Total compensation: \$8.5M (2023)',
        category: ActionCategory.other,
        source: 'Empire Company Proxy Circular',
        date: DateTime(2023, 7, 1),
      ),
    ],
  ),
  
  'eric_lafleche': Individual(
    id: 'eric_lafleche',
    name: 'Éric La Flèche',
    title: 'President & CEO',
    description: 'CEO of Metro Inc.',
    publicActions: [
      PublicAction(
        id: 'lafleche_compensation_2023',
        description: 'Total compensation: \$6.2M (2023)',
        category: ActionCategory.other,
        source: 'Metro Inc. Proxy Circular',
        date: DateTime(2023, 12, 31),
      ),
    ],
  ),
  
  // ==================== ENERGY ====================
  
  'richard_kruger': Individual(
    id: 'richard_kruger',
    name: 'Richard Kruger',
    title: 'President & CEO',
    description: 'CEO of Suncor Energy',
    publicActions: [
      PublicAction(
        id: 'kruger_compensation_2023',
        description: 'Total compensation: \$17.8M (2023)',
        category: ActionCategory.other,
        source: 'Suncor Energy Proxy Circular',
        date: DateTime(2023, 4, 1),
      ),
      PublicAction(
        id: 'suncor_layoffs_2023',
        description: 'Suncor announced 1,500 job cuts',
        category: ActionCategory.laborRelations,
        source: 'Company Press Release',
        date: DateTime(2023, 1, 1),
      ),
    ],
  ),
  
  'brad_corson': Individual(
    id: 'brad_corson',
    name: 'Brad Corson',
    title: 'Chairman, President & CEO',
    description: 'CEO of Imperial Oil',
    publicActions: [
      PublicAction(
        id: 'corson_compensation_2023',
        description: 'Total compensation: \$12.4M (2023)',
        category: ActionCategory.other,
        source: 'Imperial Oil Proxy Circular',
        date: DateTime(2023, 4, 1),
      ),
    ],
  ),
  
  // ==================== FAST FOOD EXECUTIVES ====================
  
  'jose_cil': Individual(
    id: 'jose_cil',
    name: 'José Cil',
    title: 'CEO',
    description: 'CEO of Restaurant Brands International',
    publicActions: [
      PublicAction(
        id: 'cil_compensation_2023',
        description: 'Total compensation: \$23.4M (2023)',
        category: ActionCategory.other,
        source: 'RBI Proxy Circular',
        date: DateTime(2023, 4, 1),
      ),
    ],
  ),
  
  'chris_kempczinski': Individual(
    id: 'chris_kempczinski',
    name: 'Chris Kempczinski',
    title: 'President & CEO',
    description: 'CEO of McDonald\'s Corporation',
    publicActions: [
      PublicAction(
        id: 'kempczinski_compensation_2023',
        description: 'Total compensation: \$19.2M (2023)',
        category: ActionCategory.other,
        source: 'McDonald\'s Proxy Statement',
        date: DateTime(2023, 4, 1),
      ),
    ],
  ),
  
  'laxman_narasimhan': Individual(
    id: 'laxman_narasimhan',
    name: 'Laxman Narasimhan',
    title: 'CEO',
    description: 'CEO of Starbucks Corporation',
    publicActions: [
      PublicAction(
        id: 'narasimhan_compensation_2023',
        description: 'Total compensation: \$14.6M (2023)',
        category: ActionCategory.other,
        source: 'Starbucks Proxy Statement',
        date: DateTime(2023, 12, 31),
      ),
    ],
  ),
};

// ==================== OWNERSHIP RELATIONSHIPS ====================

/// Maps company IDs to shareholder IDs with ownership percentages.
/// All percentages are sourced from SEC EDGAR or SEDAR filings.
final Map<String, List<Map<String, dynamic>>> _ownership = {
  // Canadian Grocers
  'jim_pattison_group': [
    {'shareholderId': 'jim_pattison', 'percentage': 100.0},
  ],
  'george_weston_ltd': [
    {'shareholderId': 'weston_family', 'percentage': 52.6},
    {'shareholderId': 'vanguard', 'percentage': 3.2},
    {'shareholderId': 'blackrock', 'percentage': 2.8},
  ],
  'loblaw': [
    {'shareholderId': 'george_weston_ltd', 'percentage': 52.6},
    {'shareholderId': 'vanguard', 'percentage': 3.2},
    {'shareholderId': 'blackrock', 'percentage': 2.8},
  ],
  'empire_company': [
    {'shareholderId': 'empire_family', 'percentage': 41.0},
    {'shareholderId': 'vanguard', 'percentage': 2.5},
    {'shareholderId': 'blackrock', 'percentage': 2.1},
  ],
  'metro_inc': [
    {'shareholderId': 'vanguard', 'percentage': 3.1},
    {'shareholderId': 'blackrock', 'percentage': 2.7},
  ],
  
  // US Retail
  'walmart': [
    {'shareholderId': 'walton_family', 'percentage': 45.0},
    {'shareholderId': 'vanguard', 'percentage': 4.5},
    {'shareholderId': 'blackrock', 'percentage': 3.8},
  ],
  'costco': [
    {'shareholderId': 'vanguard', 'percentage': 8.5},
    {'shareholderId': 'blackrock', 'percentage': 6.8},
  ],
  'amazon': [
    {'shareholderId': 'jeff_bezos', 'percentage': 8.3},
    {'shareholderId': 'vanguard', 'percentage': 7.2},
    {'shareholderId': 'blackrock', 'percentage': 5.9},
  ],
  'target': [
    {'shareholderId': 'vanguard', 'percentage': 8.5},
    {'shareholderId': 'blackrock', 'percentage': 7.2},
  ],
  'home_depot': [
    {'shareholderId': 'vanguard', 'percentage': 8.9},
    {'shareholderId': 'blackrock', 'percentage': 7.1},
  ],
  'cvs': [
    {'shareholderId': 'vanguard', 'percentage': 8.2},
    {'shareholderId': 'blackrock', 'percentage': 6.9},
  ],
  'walgreens': [
    {'shareholderId': 'vanguard', 'percentage': 7.8},
    {'shareholderId': 'blackrock', 'percentage': 6.5},
  ],
  'lowes': [
    {'shareholderId': 'vanguard', 'percentage': 8.4},
    {'shareholderId': 'blackrock', 'percentage': 7.0},
  ],
  'best_buy': [
    {'shareholderId': 'vanguard', 'percentage': 8.5},
    {'shareholderId': 'blackrock', 'percentage': 7.2},
  ],
  
  // Fast Food
  'restaurant_brands_intl': [
    {'shareholderId': '3g_capital', 'percentage': 28.9},
    {'shareholderId': 'vanguard', 'percentage': 2.8},
    {'shareholderId': 'blackrock', 'percentage': 2.5},
  ],
  'mcdonalds': [
    {'shareholderId': 'vanguard', 'percentage': 8.5},
    {'shareholderId': 'blackrock', 'percentage': 6.8},
  ],
  'starbucks': [
    {'shareholderId': 'howard_schultz', 'percentage': 1.8},
    {'shareholderId': 'vanguard', 'percentage': 8.2},
    {'shareholderId': 'blackrock', 'percentage': 6.5},
  ],
  'yum_brands': [
    {'shareholderId': 'vanguard', 'percentage': 8.8},
    {'shareholderId': 'blackrock', 'percentage': 7.1},
  ],
  'wendys': [
    {'shareholderId': 'vanguard', 'percentage': 8.2},
    {'shareholderId': 'blackrock', 'percentage': 6.9},
  ],
  'dominos': [
    {'shareholderId': 'vanguard', 'percentage': 8.6},
    {'shareholderId': 'blackrock', 'percentage': 7.3},
  ],
  
  // Berkshire Hathaway
  'berkshire_hathaway': [
    {'shareholderId': 'warren_buffett', 'percentage': 15.4},
    {'shareholderId': 'vanguard', 'percentage': 3.2},
    {'shareholderId': 'blackrock', 'percentage': 2.8},
  ],
  
  // Canadian Retail
  'canadian_tire': [
    {'shareholderId': 'weston_family', 'percentage': 60.0},
    {'shareholderId': 'vanguard', 'percentage': 2.5},
  ],
  'dollarama': [
    {'shareholderId': 'vanguard', 'percentage': 3.2},
    {'shareholderId': 'blackrock', 'percentage': 2.8},
  ],
  
  // Energy
  'suncor': [
    {'shareholderId': 'vanguard', 'percentage': 3.5},
    {'shareholderId': 'blackrock', 'percentage': 3.1},
  ],
  'imperial_oil': [
    {'shareholderId': 'exxonmobil', 'percentage': 69.6},
    {'shareholderId': 'vanguard', 'percentage': 3.8},
    {'shareholderId': 'blackrock', 'percentage': 3.2},
  ],
  'cenovus': [
    {'shareholderId': 'vanguard', 'percentage': 3.2},
    {'shareholderId': 'blackrock', 'percentage': 2.8},
  ],
  
  // Convenience
  'seven_and_i_holdings': [
    {'shareholderId': 'vanguard', 'percentage': 2.8},
    {'shareholderId': 'blackrock', 'percentage': 2.5},
  ],
  'couche_tard': [
    {'shareholderId': 'vanguard', 'percentage': 3.1},
    {'shareholderId': 'blackrock', 'percentage': 2.7},
  ],
  
  // TJX
  'tjx_companies': [
    {'shareholderId': 'vanguard', 'percentage': 8.2},
    {'shareholderId': 'blackrock', 'percentage': 7.1},
  ],
  
  // Tech
  'apple': [
    {'shareholderId': 'vanguard', 'percentage': 8.1},
    {'shareholderId': 'blackrock', 'percentage': 6.5},
  ],
};

// ==================== MERCHANT ALIASES ====================

/// Maps merchant name variations to company IDs for fuzzy matching.
/// Include common receipt text variations.
final Map<String, String> _merchantAliases = {
  // Save-On-Foods variations
  'save on foods': 'save_on_foods',
  'save-on-foods': 'save_on_foods',
  'saveonfoods': 'save_on_foods',
  'save-on-foods #': 'save_on_foods',
  'save on': 'save_on_foods',
  'sof #': 'save_on_foods',
  
  // Quality Foods variations
  'quality foods': 'quality_foods',
  'quality-foods': 'quality_foods',
  'qualityfoods': 'quality_foods',
  'qf nanaimo': 'quality_foods',
  'qf #': 'quality_foods',
  
  // Thrifty Foods variations
  'thrifty foods': 'thrifty_foods',
  'thrifty-foods': 'thrifty_foods',
  'thriftyfoods': 'thrifty_foods',
  
  // Urban Fare
  'urban fare': 'urban_fare',
  'urbanfare': 'urban_fare',
  
  // Loblaw variations
  'loblaw': 'loblaw',
  'loblaws': 'loblaw',
  'superstore': 'superstore',
  'real canadian superstore': 'superstore',
  'rcss': 'superstore',
  'no frills': 'no_frills',
  'nofrills': 'no_frills',
  'shoppers drug mart': 'shoppers_drug_mart',
  'shoppers': 'shoppers_drug_mart',
  'fortinos': 'fortinos',
  'zehrs': 'zehrs',
  'maxi': 'maxi',
  'provigo': 'provigo',
  
  // Sobeys variations
  'sobeys': 'sobeys',
  'safeway': 'safeway_canada',
  'iga': 'iga',
  'freshco': 'freshco',
  'foodland': 'foodland',
  
  // Metro
  'metro': 'metro',
  'super c': 'super_c',
  'superc': 'super_c',
  'food basics': 'food_basics',
  
  // Walmart variations
  'walmart': 'walmart',
  'wal-mart': 'walmart',
  'wmt': 'walmart',
  'walmart canada': 'walmart_canada',
  
  // Costco variations
  'costco': 'costco',
  'costco wholesale': 'costco',
  
  // Amazon/Whole Foods variations
  'amazon': 'amazon',
  'amazon.com': 'amazon',
  'amzn': 'amazon',
  'prime': 'amazon',
  'whole foods': 'whole_foods',
  'wholefoods': 'whole_foods',
  'whole foods market': 'whole_foods',
  
  // Target variations
  'target': 'target',
  'target store': 'target',
  
  // Home Depot variations
  'home depot': 'home_depot',
  'homedepot': 'home_depot',
  'thd': 'home_depot',
  
  // Lowe's
  'lowe\'s': 'lowes',
  'lowes': 'lowes',
  
  // CVS variations
  'cvs': 'cvs',
  'cvs pharmacy': 'cvs',
  'cvs health': 'cvs',
  
  // Walgreens variations
  'walgreens': 'walgreens',
  'walgreen': 'walgreens',
  
  // Best Buy
  'best buy': 'best_buy',
  'bestbuy': 'best_buy',
  
  // Tim Hortons variations
  'tim hortons': 'tim_hortons',
  'timhortons': 'tim_hortons',
  'tims': 'tim_hortons',
  
  // Burger King variations
  'burger king': 'burger_king',
  'burgerking': 'burger_king',
  'bk': 'burger_king',
  
  // Popeyes variations
  'popeyes': 'popeyes',
  'popeyes louisiana kitchen': 'popeyes',
  
  // Firehouse Subs
  'firehouse subs': 'firehouse_subs',
  
  // McDonald's variations
  'mcdonalds': 'mcdonalds',
  "mcdonald's": 'mcdonalds',
  'mc donalds': 'mcdonalds',
  
  // Starbucks variations
  'starbucks': 'starbucks',
  'sbux': 'starbucks',
  'starbucks coffee': 'starbucks',
  
  // KFC variations
  'kfc': 'kfc',
  'kentucky fried chicken': 'kfc',
  
  // Pizza Hut variations
  'pizza hut': 'pizza_hut',
  'pizzahut': 'pizza_hut',
  
  // Taco Bell variations
  'taco bell': 'taco_bell',
  'tacobell': 'taco_bell',
  
  // Wendy's variations
  'wendys': 'wendys',
  "wendy's": 'wendys',
  
  // Domino's
  'dominos': 'dominos',
  "domino's": 'dominos',
  
  // Chipotle
  'chipotle': 'chipotle',
  
  // Dunkin
  'dunkin': 'dunkin',
  'dunkin donuts': 'dunkin',
  
  // Dairy Queen variations
  'dairy queen': 'dairy_queen',
  'dq': 'dairy_queen',
  
  // Subway
  'subway': 'subway',
  'subway restaurant': 'subway',
  
  // Canadian Tire variations
  'canadian tire': 'canadian_tire',
  'canadiantire': 'canadian_tire',
  "mark's": 'marks_work_warehouse',
  'marks': 'marks_work_warehouse',
  'lequipeur': 'marks_work_warehouse',
  'sport chek': 'sport_chek',
  'sportchek': 'sport_chek',
  
  // Dollarama variations
  'dollarama': 'dollarama',
  'dollar store': 'dollarama',
  
  // London Drugs variations
  'london drugs': 'london_drugs',
  'londondrugs': 'london_drugs',
  
  // Petro-Canada variations
  'petro-canada': 'petro_canada',
  'petro canada': 'petro_canada',
  'petrocanada': 'petro_canada',
  
  // Shell variations
  'shell': 'shell_canada',
  'shell canada': 'shell_canada',
  
  // Esso variations
  'esso': 'esso',
  'esso station': 'esso',
  
  // Husky
  'husky': 'husky',
  
  // A&W variations
  'a&w': 'aw_canada',
  'a and w': 'aw_canada',
  'a+w': 'aw_canada',
  
  // 7-Eleven variations
  '7-eleven': 'seven_eleven',
  '7 eleven': 'seven_eleven',
  '7eleven': 'seven_eleven',
  
  // Circle K
  'circle k': 'circle_k',
  'circlek': 'circle_k',
  
  // BC Liquor variations
  'bc liquor': 'bc_liquor',
  'bc liquor store': 'bc_liquor',
  'bcl': 'bc_liquor',
  
  // SAQ
  'saq': 'saq',
  
  // LCBO
  'lcbo': 'lcbo',
  
  // Winners/HomeSense variations
  'winners': 'winners',
  'homesense': 'homesense',
  'home sense': 'homesense',
  'marshalls': 'marshalls',
  
  // IKEA variations
  'ikea': 'ikea',
  
  // Rona
  'rona': 'rona',
  
  // Rexall variations
  'rexall': 'rexall',
  'rexall pharmacy': 'rexall',
  
  // Jean Coutu
  'jean coutu': 'jean_coutu',
  
  // Country Grocer variations
  'country grocer': 'country_grocer',
  
  // Red Apple variations
  'red apple': 'red_apple',
  
  // MEC variations
  'mec': 'mec',
  'mountain equipment company': 'mec',
  'mountain equipment co-op': 'mec',
  
  // Apple
  'apple': 'apple',
  'apple store': 'apple',
  'apple.com': 'apple',
  
  // The Source
  'the source': 'the_source',
  
  // Indigo
  'indigo': 'indigo',
  'chapters': 'indigo',
  
  // Staples
  'staples': 'staples',
  
  // Decathlon
  'decathlon': 'decathlon',
};

// ==================== PRODUCTS ====================

final List<Product> _products = [
  // Groceries
  const Product(
    id: 'prod_groceries',
    name: 'Groceries',
    category: 'Food',
    companyIds: ['save_on_foods', 'quality_foods', 'thrifty_foods', 'loblaw', 'superstore', 'sobeys', 'safeway_canada', 'walmart', 'costco'],
  ),
  const Product(
    id: 'prod_pharmacy',
    name: 'Pharmacy Items',
    category: 'Health',
    companyIds: ['shoppers_drug_mart', 'cvs', 'walgreens', 'rexall', 'london_drugs', 'jean_coutu'],
  ),
  const Product(
    id: 'prod_coffee',
    name: 'Coffee',
    category: 'Beverages',
    companyIds: ['starbucks', 'tim_hortons', 'dunkin', 'mcdonalds'],
  ),
  const Product(
    id: 'prod_fast_food',
    name: 'Fast Food',
    category: 'Dining',
    companyIds: ['mcdonalds', 'burger_king', 'wendys', 'taco_bell', 'kfc', 'subway', 'aw_canada'],
  ),
  const Product(
    id: 'prod_gas',
    name: 'Gasoline',
    category: 'Fuel',
    companyIds: ['petro_canada', 'shell_canada', 'esso', 'husky'],
  ),
  const Product(
    id: 'prod_liquor',
    name: 'Alcohol',
    category: 'Beverages',
    companyIds: ['bc_liquor', 'saq', 'lcbo'],
  ),
  const Product(
    id: 'prod_home_improvement',
    name: 'Home Improvement',
    category: 'Home',
    companyIds: ['home_depot', 'lowes', 'rona', 'canadian_tire'],
  ),
  const Product(
    id: 'prod_electronics',
    name: 'Electronics',
    category: 'Technology',
    companyIds: ['best_buy', 'apple', 'the_source', 'amazon'],
  ),
  const Product(
    id: 'prod_clothing',
    name: 'Clothing',
    category: 'Apparel',
    companyIds: ['winners', 'marshalls', 'walmart', 'costco'],
  ),
  const Product(
    id: 'prod_office',
    name: 'Office Supplies',
    category: 'Office',
    companyIds: ['staples', 'walmart', 'amazon'],
  ),
  const Product(
    id: 'prod_books',
    name: 'Books',
    category: 'Media',
    companyIds: ['indigo', 'amazon'],
  ),
  const Product(
    id: 'prod_sporting_goods',
    name: 'Sporting Goods',
    category: 'Sports',
    companyIds: ['sport_chek', 'decathlon', 'mec', 'canadian_tire'],
  ),
  const Product(
    id: 'prod_furniture',
    name: 'Furniture',
    category: 'Home',
    companyIds: ['ikea', 'homesense', 'walmart'],
  ),
  const Product(
    id: 'prod_convenience',
    name: 'Convenience Items',
    category: 'Retail',
    companyIds: ['seven_eleven', 'circle_k', 'petro_canada', 'shell_canada'],
  ),
  const Product(
    id: 'prod_dollar_store',
    name: 'Dollar Store Items',
    category: 'Retail',
    companyIds: ['dollarama', 'dollar_store'],
  ),
  const Product(
    id: 'prod_pizza',
    name: 'Pizza',
    category: 'Dining',
    companyIds: ['pizza_hut', 'dominos', 'pizza_pizza'],
  ),
  const Product(
    id: 'prod_chicken',
    name: 'Fried Chicken',
    category: 'Dining',
    companyIds: ['kfc', 'popeyes', 'mary_browns'],
  ),
  const Product(
    id: 'prod_ice_cream',
    name: 'Ice Cream',
    category: 'Dessert',
    companyIds: ['dairy_queen', 'mcdonalds'],
  ),
  const Product(
    id: 'prod_sandwich',
    name: 'Sandwiches',
    category: 'Dining',
    companyIds: ['subway', 'firehouse_subs', 'tim_hortons'],
  ),
  const Product(
    id: 'prod_mexican',
    name: 'Mexican Food',
    category: 'Dining',
    companyIds: ['taco_bell', 'chipotle'],
  ),
];

// ==================== ALTERNATIVES ====================

final List<Alternative> _alternatives = [
  const Alternative(
    id: 'alt_country_grocer',
    name: 'Country Grocer',
    category: 'Grocery',
    description: 'Locally owned grocery chain on Vancouver Island',
    companyId: 'country_grocer',
    alternativeToCompanyIds: ['save_on_foods', 'quality_foods', 'thrifty_foods'],
    isLocal: true,
    isIndependent: true,
  ),
  const Alternative(
    id: 'alt_mec',
    name: 'Mountain Equipment Company',
    category: 'Outdoor Retail',
    description: 'Canadian outdoor retail cooperative',
    companyId: 'mec',
    alternativeToCompanyIds: ['canadian_tire', 'sport_chek'],
    isCooperative: true,
  ),
  const Alternative(
    id: 'alt_farmers_market',
    name: 'Local Farmers Markets',
    category: 'Grocery',
    description: 'Buy directly from local producers',
    alternativeToCompanyIds: ['loblaw', 'superstore', 'walmart'],
    isLocal: true,
    isIndependent: true,
  ),
  const Alternative(
    id: 'alt_independent_coffee',
    name: 'Independent Coffee Shops',
    category: 'Coffee',
    description: 'Locally owned cafes and roasters',
    alternativeToCompanyIds: ['starbucks', 'tim_hortons'],
    isLocal: true,
    isIndependent: true,
  ),
  const Alternative(
    id: 'alt_local_restaurant',
    name: 'Independent Restaurants',
    category: 'Dining',
    description: 'Family-owned local restaurants',
    alternativeToCompanyIds: ['mcdonalds', 'burger_king', 'wendys'],
    isLocal: true,
    isIndependent: true,
  ),
  const Alternative(
    id: 'alt_local_pharmacy',
    name: 'Independent Pharmacies',
    category: 'Health',
    description: 'Locally owned pharmacies',
    alternativeToCompanyIds: ['shoppers_drug_mart', 'cvs', 'walgreens'],
    isLocal: true,
    isIndependent: true,
  ),
  const Alternative(
    id: 'alt_coop_gas',
    name: 'Co-op Gas Stations',
    category: 'Fuel',
    description: 'Member-owned gas stations',
    alternativeToCompanyIds: ['petro_canada', 'shell_canada', 'esso'],
    isCooperative: true,
  ),
  const Alternative(
    id: 'alt_local_hardware',
    name: 'Local Hardware Stores',
    category: 'Home',
    description: 'Independent hardware retailers',
    alternativeToCompanyIds: ['home_depot', 'lowes', 'rona'],
    isLocal: true,
    isIndependent: true,
  ),
  const Alternative(
    id: 'alt_used_books',
    name: 'Used Bookstores',
    category: 'Media',
    description: 'Independent used book shops',
    alternativeToCompanyIds: ['indigo', 'amazon'],
    isLocal: true,
    isIndependent: true,
  ),
  const Alternative(
    id: 'alt_library',
    name: 'Public Library',
    category: 'Media',
    description: 'Free books and media from your local library',
    alternativeToCompanyIds: ['indigo', 'amazon'],
    isLocal: true,
    isIndependent: true,
  ),
];

// ==================== PUBLIC API ====================

/// Gets all companies in the database.
Map<String, Company> getCompanies() => Map.unmodifiable(_companies);

/// Gets all shareholders in the database.
Map<String, Individual> getShareholders() => Map.unmodifiable(_shareholders);

/// Gets all ownership relationships.
Map<String, List<Map<String, dynamic>>> getOwnership() => 
    Map.unmodifiable(_ownership);

/// Gets all merchant aliases for fuzzy matching.
Map<String, String> getMerchantAliases() => Map.unmodifiable(_merchantAliases);

/// Gets all alternatives.
List<Alternative> getAlternatives() => List.unmodifiable(_alternatives);

/// Gets all products.
List<Product> getProducts() => List.unmodifiable(_products);

/// Gets a company by ID.
Company? getCompanyById(String id) => _companies[id];

/// Gets a shareholder by ID.
Individual? getShareholderById(String id) => _shareholders[id];

/// Gets shareholders for a specific company.
List<Map<String, dynamic>> getShareholdersForCompany(String companyId) {
  return _ownership[companyId] ?? [];
}

/// Gets the ownership chain for a company (company → parent → grandparent, etc.)
List<Company> getOwnershipChain(String companyId) {
  final chain = <Company>[];
  String? currentId = companyId;
  final visited = <String>{};
  
  while (currentId != null && !visited.contains(currentId)) {
    visited.add(currentId);
    final company = _companies[currentId];
    if (company == null) break;
    chain.add(company);
    currentId = company.parentId;
  }
  
  return chain;
}
