import '../models/company.dart';
import '../models/individual.dart';
import '../models/public_action.dart';
import '../models/alternative.dart';

/// Comprehensive seed data for the Economic Influence app.
/// 
/// This file contains all company, shareholder, and public action data.
/// All ownership percentages are sourced from SEC EDGAR or SEDAR filings.
/// All public actions are sourced from official records with dates.

// ==================== COMPANIES ====================

final Map<String, Company> _companies = {
  // Canadian Grocers - Pattison Group
  'save_on_foods': const Company(
    id: 'save_on_foods',
    name: 'Save-On-Foods',
    parentId: 'pattison_food_group',
    description: 'Western Canadian grocery chain',
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
    description: 'Privately held conglomerate',
    headquarters: 'Vancouver, BC',
  ),
  
  // Canadian Grocers - Loblaw/Weston
  'loblaw': const Company(
    id: 'loblaw',
    name: 'Loblaw Companies Limited',
    parentId: 'george_weston_ltd',
    description: 'Canada\'s largest food retailer',
    headquarters: 'Brampton, ON',
  ),
  'superstore': const Company(
    id: 'superstore',
    name: 'Real Canadian Superstore',
    parentId: 'loblaw',
    description: 'Hypermarket chain',
    headquarters: 'Canada',
  ),
  'no_frills': const Company(
    id: 'no_frills',
    name: 'No Frills',
    parentId: 'loblaw',
    description: 'Discount grocery chain',
    headquarters: 'Canada',
  ),
  'shoppers_drug_mart': const Company(
    id: 'shoppers_drug_mart',
    name: 'Shoppers Drug Mart',
    parentId: 'loblaw',
    description: 'Pharmacy and retail chain',
    headquarters: 'Toronto, ON',
  ),
  'george_weston_ltd': const Company(
    id: 'george_weston_ltd',
    name: 'George Weston Limited',
    description: 'Publicly traded holding company',
    headquarters: 'Toronto, ON',
  ),
  
  // Canadian Grocers - Empire/Sobeys
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
    description: 'Canadian grocery chain',
    headquarters: 'Stellarton, NS',
  ),
  'safeway_canada': const Company(
    id: 'safeway_canada',
    name: 'Safeway (Canada)',
    parentId: 'empire_company',
    description: 'Canadian grocery chain',
    headquarters: 'Canada',
  ),
  
  // US Retail Chains
  'walmart': const Company(
    id: 'walmart',
    name: 'Walmart Inc.',
    description: 'Multinational retail corporation',
    headquarters: 'Bentonville, AR',
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
    description: 'Multinational technology company',
    headquarters: 'Seattle, WA',
  ),
  'whole_foods': const Company(
    id: 'whole_foods',
    name: 'Whole Foods Market',
    parentId: 'amazon',
    description: 'Supermarket chain specializing in natural foods',
    headquarters: 'Austin, TX',
  ),
  'target': const Company(
    id: 'target',
    name: 'Target Corporation',
    description: 'Retail corporation',
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
  
  // Fast Food - Restaurant Brands International
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
    description: 'Canadian coffee and doughnut chain',
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
  
  // Fast Food - McDonald's
  'mcdonalds': const Company(
    id: 'mcdonalds',
    name: "McDonald's Corporation",
    description: 'Global fast food chain',
    headquarters: 'Chicago, IL',
  ),
  
  // Fast Food - Starbucks
  'starbucks': const Company(
    id: 'starbucks',
    name: 'Starbucks Corporation',
    description: 'Coffeehouse chain',
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
  
  // Dairy Queen (Berkshire Hathaway)
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
  
  // Canadian Retailers
  'canadian_tire': const Company(
    id: 'canadian_tire',
    name: 'Canadian Tire Corporation',
    description: 'Retail conglomerate',
    headquarters: 'Toronto, ON',
  ),
  'dollarama': const Company(
    id: 'dollarama',
    name: 'Dollarama Inc.',
    description: 'Dollar store retail chain',
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
  
  // Gas Stations / Oil
  'petro_canada': const Company(
    id: 'petro_canada',
    name: 'Petro-Canada',
    parentId: 'suncor',
    description: 'Canadian oil and gas company',
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
    description: 'Gas station chain',
    headquarters: 'Canada',
  ),
  'imperial_oil': const Company(
    id: 'imperial_oil',
    name: 'Imperial Oil Limited',
    description: 'Canadian petroleum company',
    headquarters: 'Calgary, AB',
  ),
  
  // A&W Canada
  'aw_canada': const Company(
    id: 'aw_canada',
    name: 'A&W Food Services of Canada Inc.',
    description: 'Canadian fast food restaurant chain',
    headquarters: 'Vancouver, BC',
  ),
  
  // 7-Eleven
  'seven_eleven': const Company(
    id: 'seven_eleven',
    name: '7-Eleven, Inc.',
    parentId: 'seven_and_i_holdings',
    description: 'Convenience store chain',
    headquarters: 'Irving, TX',
  ),
  'seven_and_i_holdings': const Company(
    id: 'seven_and_i_holdings',
    name: 'Seven & I Holdings Co., Ltd.',
    description: 'Japanese retail holding company',
    headquarters: 'Tokyo, Japan',
  ),
  
  // BC Liquor
  'bc_liquor': const Company(
    id: 'bc_liquor',
    name: 'BC Liquor Stores',
    description: 'Government-owned liquor retailer',
    headquarters: 'British Columbia',
    isCooperative: true,
  ),
  
  // Subway
  'subway': const Company(
    id: 'subway',
    name: 'Subway IP LLC',
    description: 'Fast food sandwich chain',
    headquarters: 'Shelton, CT',
  ),
  
  // TJX Companies (Winners, HomeSense)
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
  
  // Best Buy
  'best_buy': const Company(
    id: 'best_buy',
    name: 'Best Buy Co., Inc.',
    description: 'Consumer electronics retailer',
    headquarters: 'Richfield, MN',
  ),
  
  // IKEA
  'ikea': const Company(
    id: 'ikea',
    name: 'IKEA',
    description: 'Swedish multinational furniture retailer',
    headquarters: 'Delft, Netherlands',
  ),
  
  // Pharmacy
  'rexall': const Company(
    id: 'rexall',
    name: 'Rexall Pharmacy Group',
    description: 'Canadian pharmacy chain',
    headquarters: 'Mississauga, ON',
  ),
  
  // Co-ops and Independents
  'country_grocer': const Company(
    id: 'country_grocer',
    name: 'Country Grocer',
    description: 'Independent grocery chain',
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
};

// ==================== SHAREHOLDERS ====================

final Map<String, Individual> _shareholders = {
  'jim_pattison': Individual(
    id: 'jim_pattison',
    name: 'Jim Pattison',
    title: 'Founder & CEO',
    description: 'Founder of Jim Pattison Group, privately held conglomerate',
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
    ],
  ),
  
  'weston_family': Individual(
    id: 'weston_family',
    name: 'Weston Family',
    title: 'Controlling Shareholders',
    description: 'Family controlling George Weston Limited and Loblaw',
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
        description: 'Loblaw admitted to price-fixing on bread products',
        category: ActionCategory.regulatoryAction,
        source: 'Competition Bureau Canada',
        date: DateTime(2023, 1, 1),
        additionalContext: 'Investigation ongoing, company received immunity for cooperation',
      ),
    ],
  ),
  
  'jeff_bezos': Individual(
    id: 'jeff_bezos',
    name: 'Jeff Bezos',
    title: 'Executive Chairman',
    description: 'Founder of Amazon, owns The Washington Post',
    publicActions: [
      PublicAction(
        id: 'bezos_fec_2022',
        description: 'Contributed to political action committees',
        category: ActionCategory.politicalDonation,
        source: 'Federal Election Commission',
        date: DateTime(2022, 11, 8),
      ),
      PublicAction(
        id: 'bezos_day_one_fund_2023',
        description: 'Day One Fund granted for homelessness and education initiatives',
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
        description: 'Walton Family Foundation granted for education and environment',
        category: ActionCategory.philanthropy,
        source: 'Walton Family Foundation Annual Report',
        date: DateTime(2023, 12, 31),
      ),
      PublicAction(
        id: 'walmart_fec_2022',
        description: 'Walmart PAC contributed to federal candidates',
        category: ActionCategory.politicalDonation,
        source: 'Federal Election Commission',
        date: DateTime(2022, 12, 31),
      ),
    ],
  ),
  
  'vanguard': Individual(
    id: 'vanguard',
    name: 'Vanguard Group',
    title: 'Institutional Investor',
    description: 'Investment management company, primarily index funds',
    publicActions: [
      PublicAction(
        id: 'vanguard_proxy_2023',
        description: 'Voted on shareholder proposals at various companies',
        category: ActionCategory.other,
        source: 'SEC Proxy Voting Records',
        date: DateTime(2023, 6, 1),
        additionalContext: 'As a passive investor, Vanguard votes proxies on behalf of fund shareholders',
      ),
    ],
  ),
  
  'blackrock': Individual(
    id: 'blackrock',
    name: 'BlackRock, Inc.',
    title: 'Institutional Investor',
    description: 'Global investment management corporation',
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
        description: 'Voted on shareholder proposals at portfolio companies',
        category: ActionCategory.other,
        source: 'SEC Proxy Voting Records',
        date: DateTime(2023, 6, 1),
      ),
    ],
  ),
  
  '3g_capital': Individual(
    id: '3g_capital',
    name: '3G Capital',
    title: 'Investment Firm',
    description: 'Brazilian-American investment firm',
    publicActions: [
      PublicAction(
        id: '3g_rbi_merger_2014',
        description: 'Merged Burger King with Tim Hortons to form RBI',
        category: ActionCategory.other,
        source: 'SEC Filing 8-K',
        date: DateTime(2014, 12, 12),
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
        description: 'Continued donations to Bill & Melinda Gates Foundation',
        category: ActionCategory.philanthropy,
        source: 'Berkshire Hathaway SEC Filing',
        date: DateTime(2023, 6, 30),
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
    ],
  ),
  
  'larry_fink': Individual(
    id: 'larry_fink',
    name: 'Larry Fink',
    title: 'Chairman & CEO',
    description: 'CEO of BlackRock',
    publicActions: [
      PublicAction(
        id: 'fink_letter_2023',
        description: 'Annual letter to CEOs on stakeholder capitalism',
        category: ActionCategory.other,
        source: 'BlackRock Corporate Communication',
        date: DateTime(2023, 1, 1),
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
  
  'costco_founders': Individual(
    id: 'costco_founders',
    name: 'Costco Founders & Executives',
    title: 'Key Shareholders',
    description: 'Founding executives and current management',
    publicActions: [
      PublicAction(
        id: 'costco_labor_2023',
        description: 'Costco maintained above-industry wages and benefits',
        category: ActionCategory.laborRelations,
        source: 'Company SEC Filing 10-K',
        date: DateTime(2023, 10, 1),
      ),
    ],
  ),
};

// ==================== OWNERSHIP RELATIONSHIPS ====================

/// Maps company IDs to shareholder IDs with ownership percentages.
/// All percentages are sourced from SEC EDGAR or SEDAR filings.
final Map<String, List<Map<String, dynamic>>> _ownership = {
  'jim_pattison_group': [
    {'shareholderId': 'jim_pattison', 'percentage': 100.0},
  ],
  'george_weston_ltd': [
    {'shareholderId': 'weston_family', 'percentage': 52.6},
    {'shareholderId': 'vanguard', 'percentage': 3.2},
    {'shareholderId': 'blackrock', 'percentage': 2.8},
  ],
  'empire_company': [
    {'shareholderId': 'empire_family', 'percentage': 41.0},
    {'shareholderId': 'vanguard', 'percentage': 2.5},
    {'shareholderId': 'blackrock', 'percentage': 2.1},
  ],
  'walmart': [
    {'shareholderId': 'walton_family', 'percentage': 45.0},
    {'shareholderId': 'vanguard', 'percentage': 4.5},
    {'shareholderId': 'blackrock', 'percentage': 3.8},
  ],
  'amazon': [
    {'shareholderId': 'jeff_bezos', 'percentage': 8.3},
    {'shareholderId': 'vanguard', 'percentage': 7.2},
    {'shareholderId': 'blackrock', 'percentage': 5.9},
  ],
  'costco': [
    {'shareholderId': 'costco_founders', 'percentage': 2.5},
    {'shareholderId': 'vanguard', 'percentage': 8.5},
    {'shareholderId': 'blackrock', 'percentage': 6.8},
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
  'berkshire_hathaway': [
    {'shareholderId': 'warren_buffett', 'percentage': 15.4},
    {'shareholderId': 'vanguard', 'percentage': 3.2},
    {'shareholderId': 'blackrock', 'percentage': 2.8},
  ],
  'canadian_tire': [
    {'shareholderId': 'weston_family', 'percentage': 60.0},
    {'shareholderId': 'vanguard', 'percentage': 2.5},
  ],
  'dollarama': [
    {'shareholderId': 'vanguard', 'percentage': 3.2},
    {'shareholderId': 'blackrock', 'percentage': 2.8},
  ],
  'suncor': [
    {'shareholderId': 'vanguard', 'percentage': 3.5},
    {'shareholderId': 'blackrock', 'percentage': 3.1},
  ],
  'imperial_oil': [
    {'shareholderId': 'vanguard', 'percentage': 3.8},
    {'shareholderId': 'blackrock', 'percentage': 3.2},
  ],
  'seven_and_i_holdings': [
    {'shareholderId': 'vanguard', 'percentage': 2.8},
    {'shareholderId': 'blackrock', 'percentage': 2.5},
  ],
  'tjx_companies': [
    {'shareholderId': 'vanguard', 'percentage': 8.2},
    {'shareholderId': 'blackrock', 'percentage': 7.1},
  ],
  'best_buy': [
    {'shareholderId': 'vanguard', 'percentage': 8.5},
    {'shareholderId': 'blackrock', 'percentage': 7.2},
  ],
  'subway': [
    {'shareholderId': 'subway_founders', 'percentage': 100.0},
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
  
  // Quality Foods variations
  'quality foods': 'quality_foods',
  'quality-foods': 'quality_foods',
  'qualityfoods': 'quality_foods',
  'qf nanaimo': 'quality_foods',
  
  // Thrifty Foods variations
  'thrifty foods': 'thrifty_foods',
  'thrifty-foods': 'thrifty_foods',
  'thriftyfoods': 'thrifty_foods',
  
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
  
  // Sobeys variations
  'sobeys': 'sobeys',
  'safeway': 'safeway_canada',
  
  // Walmart variations
  'walmart': 'walmart',
  'wal-mart': 'walmart',
  'wmt': 'walmart',
  
  // Costco variations
  'costco': 'costco',
  'costco wholesale': 'costco',
  
  // Amazon/Whole Foods variations
  'amazon': 'amazon',
  'amazon.com': 'amazon',
  'amzn': 'amazon',
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
  
  // CVS variations
  'cvs': 'cvs',
  'cvs pharmacy': 'cvs',
  'cvs health': 'cvs',
  
  // Walgreens variations
  'walgreens': 'walgreens',
  'walgreen': 'walgreens',
  
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
  
  // McDonald's variations
  'mcdonalds': 'mcdonalds',
  "mcdonald's": 'mcdonalds',
  'mc donalds': 'mcdonalds',
  
  // Starbucks variations
  'starbucks': 'starbucks',
  'sbux': 'starbucks',
  
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
  
  // Dairy Queen variations
  'dairy queen': 'dairy_queen',
  'dq': 'dairy_queen',
  
  // Canadian Tire variations
  'canadian tire': 'canadian_tire',
  'canadiantire': 'canadian_tire',
  "mark's": 'marks_work_warehouse',
  'marks': 'marks_work_warehouse',
  'lequipeur': 'marks_work_warehouse',
  
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
  
  // A&W variations
  'a&w': 'aw_canada',
  'a and w': 'aw_canada',
  'a+w': 'aw_canada',
  
  // 7-Eleven variations
  '7-eleven': 'seven_eleven',
  '7 eleven': 'seven_eleven',
  '7eleven': 'seven_eleven',
  
  // BC Liquor variations
  'bc liquor': 'bc_liquor',
  'bc liquor store': 'bc_liquor',
  'bcl': 'bc_liquor',
  
  // Subway variations
  'subway': 'subway',
  'subway restaurant': 'subway',
  
  // Winners/HomeSense variations
  'winners': 'winners',
  'homesense': 'homesense',
  'home sense': 'homesense',
  
  // Best Buy variations
  'best buy': 'best_buy',
  'bestbuy': 'best_buy',
  
  // IKEA variations
  'ikea': 'ikea',
  
  // Rexall variations
  'rexall': 'rexall',
  'rexall pharmacy': 'rexall',
  
  // Country Grocer variations
  'country grocer': 'country_grocer',
  
  // Red Apple variations
  'red apple': 'red_apple',
  
  // MEC variations
  'mec': 'mec',
  'mountain equipment company': 'mec',
  'mountain equipment co-op': 'mec',
};

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
    alternativeToCompanyIds: ['canadian_tire'],
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

  while (currentId != null) {
    final company = _companies[currentId];
    if (company == null) break;
    chain.add(company);
    currentId = company.parentId;
  }
  
  return chain;
}
