/**
 * Messages & Conversations Data Store
 * Provides initial curated conversation threads and localStorage persistence.
 */

const STORAGE_KEY = 'galletrix_marketplace_messages';

export const INITIAL_CONVERSATIONS = [
  {
    id: 'conv_hyundai_tucson',
    senderName: 'Hyundai Auto Hub Verified Showroom',
    senderInitial: 'H',
    senderRole: 'Authorized Dealer',
    phone: '+91 98470 44556',
    isOnline: true,
    statusText: 'Active now • Typically replies in 5m',
    isBuying: true,
    unreadCount: 1,
    listing: {
      id: 'list_hyundai_tucson_2021',
      title: '2021 Hyundai Tucson GLS 2.0 CRDi AWD',
      price: '₹ 12,37,000',
      location: 'Kazhakkoottam, Thiruvananthapuram',
      image: '/images/hyundai_tucson.png',
      badge: 'Certified Showroom Vehicle',
    },
    messages: [
      {
        id: 'm1_1',
        text: 'Hello! I am interested in the 2021 Hyundai Tucson GLS AWD. Is it available for an inspection and test drive?',
        time: 'Yesterday, 4:15 PM',
        isFromMe: true,
        status: 'read',
      },
      {
        id: 'm1_2',
        text: 'Hello Alex! Yes, the Tucson GLS is currently available at our Kazhakkoottam showroom. Full periodic service records from Hyundai are verified.',
        time: 'Yesterday, 4:22 PM',
        isFromMe: false,
      },
      {
        id: 'm1_3',
        text: 'Would tomorrow morning around 11:00 AM work for your test drive?',
        time: 'Yesterday, 4:23 PM',
        isFromMe: false,
      },
      {
        id: 'm1_4',
        text: 'Yes, 11:00 AM works perfectly for me. Please reserve the slot.',
        time: 'Yesterday, 4:30 PM',
        isFromMe: true,
        status: 'read',
      },
      {
        id: 'm1_5',
        text: 'Slot confirmed! See you tomorrow at 11:00 AM at Hyundai Auto Hub. Our senior advisor Rahul (+91 98470 44556) will be assisting you.',
        time: '10:41 AM',
        isFromMe: false,
      },
    ],
  },
  {
    id: 'conv_hyundai_creta',
    senderName: 'Rohan Sharma',
    senderInitial: 'R',
    senderRole: 'Individual Seller',
    phone: '+91 98470 54321',
    isOnline: false,
    statusText: 'Last seen 2h ago',
    isBuying: true,
    unreadCount: 0,
    listing: {
      id: 'list_creta_2022',
      title: '2022 Hyundai Creta SX',
      price: '₹ 7,25,000',
      location: 'Kowdiar, Thiruvananthapuram',
      image: '/images/hyundai_creta_card.png',
      badge: 'Single Owner',
    },
    messages: [
      {
        id: 'm2_1',
        text: 'Hi Rohan, is the Creta SX still available? Is the price slightly negotiable?',
        time: 'Oct 4, 2:10 PM',
        isFromMe: true,
        status: 'read',
      },
      {
        id: 'm2_2',
        text: 'Hi! Yes, the car is available. I can do a minor negotiation in person after you inspect the vehicle.',
        time: 'Oct 4, 2:45 PM',
        isFromMe: false,
      },
      {
        id: 'm2_3',
        text: 'Yes, you can inspect it tomorrow near Kowdiar Palace.',
        time: 'Oct 4, 3:00 PM',
        isFromMe: false,
      },
    ],
  },
  {
    id: 'conv_urban_nest',
    senderName: 'Urban Nest Realty',
    senderInitial: 'U',
    senderRole: 'Verified Agency',
    phone: '+91 98470 99887',
    isOnline: true,
    statusText: 'Active now',
    isBuying: true,
    unreadCount: 0,
    listing: {
      id: 'list_apt_kakkanad_3bhk',
      title: '3BHK Luxury Apartment in Kakkanad',
      price: '₹ 85.0 L',
      location: 'Kakkanad, Kochi',
      image: '/images/h2.png',
      badge: 'Ready to Move',
    },
    messages: [
      {
        id: 'm3_1',
        text: 'Hello, could we arrange a physical walkthrough of the 3BHK flat this Saturday?',
        time: 'Oct 3, 11:15 AM',
        isFromMe: true,
        status: 'read',
      },
      {
        id: 'm3_2',
        text: 'The viewing is confirmed for Saturday at 4 PM. Our site manager will welcome you at the tower lobby.',
        time: 'Oct 3, 11:50 AM',
        isFromMe: false,
      },
    ],
  },
  {
    id: 'conv_priya_macbook',
    senderName: 'Priya Varma',
    senderInitial: 'P',
    senderRole: 'Interested Buyer',
    phone: '+91 98470 33221',
    isOnline: true,
    statusText: 'Active now',
    isBuying: false,
    unreadCount: 1,
    listing: {
      id: 'list_macbook_m3',
      title: '2023 MacBook Air M2 13" (Midnight)',
      price: '₹ 82,000',
      location: 'Kowdiar, Thiruvananthapuram',
      image: '/images/h5.png',
      badge: 'Your Active Ad',
    },
    messages: [
      {
        id: 'm4_1',
        text: 'Hello Alex! I saw your MacBook Air listing. Is battery health still at 98%?',
        time: '9:15 AM',
        isFromMe: false,
      },
      {
        id: 'm4_2',
        text: 'Yes Priya, battery cycle count is only 42 and health is 98%. AppleCare warranty is active till November.',
        time: '9:30 AM',
        isFromMe: true,
        status: 'read',
      },
      {
        id: 'm4_3',
        text: 'That sounds great! Is the price negotiable? Can you consider ₹ 78,000 for immediate pickup?',
        time: '10:05 AM',
        isFromMe: false,
      },
    ],
  },
  {
    id: 'conv_moto_world',
    senderName: 'Moto World Verified Showroom',
    senderInitial: 'M',
    senderRole: 'Certified Dealership',
    phone: '+91 98470 66778',
    isOnline: false,
    statusText: 'Offline',
    isBuying: true,
    unreadCount: 0,
    listing: {
      id: 'list_bike_re_hunter',
      title: 'Royal Enfield Hunter 350',
      price: '₹ 1,75,000',
      location: 'Thiruvananthapuram',
      image: '/images/bike_hunter.png',
      badge: '2023 Showroom Stock',
    },
    messages: [
      {
        id: 'm5_1',
        text: 'Hi, does this bike include the official touring visor and crash guards shown in pictures?',
        time: 'Sep 29, 6:00 PM',
        isFromMe: true,
        status: 'read',
      },
      {
        id: 'm5_2',
        text: 'Yes sir, all accessories shown in photos are included with original bills and spare key.',
        time: 'Sep 29, 6:25 PM',
        isFromMe: false,
      },
    ],
  },
];

/**
 * Loads conversations from localStorage or initializes with default threads
 */
export function getSavedConversations() {
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    if (raw) {
      const parsed = JSON.parse(raw);
      if (Array.isArray(parsed) && parsed.length > 0) {
        return parsed;
      }
    }
  } catch (err) {
    console.warn('Error reading conversations from localStorage:', err);
  }
  return INITIAL_CONVERSATIONS;
}

/**
 * Saves conversations to localStorage
 */
export function persistConversations(conversations) {
  try {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(conversations));
  } catch (err) {
    console.error('Error saving conversations:', err);
  }
}

/**
 * Total unread messages across all conversations
 */
export function calculateTotalUnread(conversations) {
  return conversations.reduce((acc, c) => acc + (c.unreadCount || 0), 0);
}
