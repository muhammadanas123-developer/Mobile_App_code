import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_assets.dart';
import 'salon_model.dart';
import 'service_model.dart';

/// Centralized Provider that exposes list of salons for search, detail, and booking flows.
/// All data is Pakistan-based with PKR pricing.
final salonsProvider = Provider<List<SalonModel>>((ref) {
  return [
    const SalonModel(
      id: '1',
      name: 'Shahnaz Hair & Beauty',
      imageUrl: AppAssets.salonInterior,
      rating: 4.8,
      reviewsCount: 128,
      description: 'Lahore\'s premier luxury salon. Specialized in bridal makeup, deep-tissue recovery therapies, and advanced hair treatments using organic herbal formulations.',
      category: 'LUXURY SPA',
      city: 'Lahore',
      address: '22 MM Alam Road, Gulberg III, Lahore',
      services: [
        ServiceModel(
          id: 's1',
          name: 'Herbal Glow Facial',
          description: 'A deep resurfacing treatment using natural botanical enzymes and organic ubtan to even out skin texture and restore radiance.',
          durationMinutes: 90,
          price: 4500.0,
          category: 'Facial',
        ),
        ServiceModel(
          id: 's2',
          name: 'Deep Tissue Massage',
          description: 'Full-body deep tissue massage with warm mustard oil and volcanic stones to relieve muscle tension.',
          durationMinutes: 90,
          price: 5500.0,
          category: 'Massage',
        ),
        ServiceModel(
          id: 's3',
          name: 'Signature Hair Colour',
          description: 'Custom balayage and ombre colouring tailored to your natural hair texture and skin tone.',
          durationMinutes: 120,
          price: 6500.0,
          category: 'Hair',
        ),
      ],
    ),
    const SalonModel(
      id: '3',
      name: 'Glow & Grace Studio',
      imageUrl: AppAssets.salonInterior,
      rating: 4.9,
      reviewsCount: 245,
      description: 'Karachi\'s bright and airy high-ceiling studio. Known for custom aromatherapy skincare, light therapy, and botanical facial matching.',
      category: 'SKIN STUDIO',
      city: 'Karachi',
      address: '15 Khayaban-e-Bukhari, DHA Phase 6, Karachi',
      services: [
        ServiceModel(
          id: 's4',
          name: 'Signature Hydro-Facial',
          description: 'Active dermal infusion for maximum skin hydration and bounce — our most booked treatment.',
          durationMinutes: 60,
          price: 3800.0,
          category: 'Facial',
        ),
        ServiceModel(
          id: 's5',
          name: 'Bridal Glow Package',
          description: 'Complete bridal prep: full-face bleach, clean-up, fruit facial, and pre-bridal hair spa.',
          durationMinutes: 180,
          price: 15000.0,
          category: 'Bridal',
        ),
      ],
    ),
    const SalonModel(
      id: '2',
      name: 'The Nail Lounge Islamabad',
      imageUrl: AppAssets.salonInterior,
      rating: 4.7,
      reviewsCount: 93,
      description: 'Islamabad\'s go-to nail art studio. Vegan, cruelty-free products with a relaxing lounge vibe in the heart of F-7.',
      category: 'NAIL BAR',
      city: 'Islamabad',
      address: 'Shop 8, Beverly Centre, Jinnah Super, F-7, Islamabad',
      services: [
        ServiceModel(
          id: 's6',
          name: 'Gel Manicure',
          description: 'Long-lasting gel manicure with a huge range of OPI and vegan shades.',
          durationMinutes: 45,
          price: 2500.0,
          category: 'Nails',
        ),
        ServiceModel(
          id: 's7',
          name: 'Spa Pedicure',
          description: 'Luxury pedicure with sea-salt scrub, hot-stone massage, and paraffin wax dip.',
          durationMinutes: 60,
          price: 3500.0,
          category: 'Nails',
        ),
      ],
    ),
  ];
});