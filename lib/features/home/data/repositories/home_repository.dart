import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qareeb/features/home/data/models/cafe_model.dart';

class HomeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // دالة جلب الفروع (لشاشة الهوم)
  Future<List<CafeModel>> getNearbyCafes() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('shops').get();
      return snapshot.docs.map((doc) => CafeModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('فشل في جلب الفروع: $e');
    }
  }

  // الدالة الشاملة لرفع الكافيهات والمنيو الخاص بكل كافيه إلى فايربيس
  Future<void> seedFullDatabaseToFirebase() async {
    print('بدأ رفع البيانات الشاملة إلى فايربيس... ⏳');

    // بيانات وهمية متكاملة لـ 3 كافيهات مع المنيو الخاص بهم
    final List<Map<String, dynamic>> shopsData = [
      {
        'name': 'روستري كافيه - Roastery',
        'imageUrl': 'https://images.unsplash.com/photo-1554118811-1e0d58224f24?auto=format&fit=crop&w=500&q=60',
        'distance': 1.2,
        'isOpen': true,
        // قائمة المنتجات التي سيتم رفعها كمجموعة فرعية (Sub-collection)
        'menu': [
          {
            'name': 'كابتشينو',
            'description': 'إسبريسو غني مع حليب مبخر وطبقة كثيفة من الرغوة.',
            'price': 3.50,
            'imageUrl': 'https://images.unsplash.com/photo-1517701604599-bb29b565090c?auto=format&fit=crop&w=500&q=60',
            'category': 'قهوة ساخنة',
            // خيارات التخصيص التي سنحتاجها في شاشة تفاصيل المشروب
            'customizations': {
              'sizes': [{'name': 'صغير', 'price': 0.0}, {'name': 'وسط', 'price': 0.50}, {'name': 'كبير', 'price': 1.0}],
              'milk': ['حليب كامل الدسم', 'حليب خالي الدسم', 'حليب الشوفان', 'حليب اللوز'],
              'sugar': ['بدون سكر', 'سكر خفيف', 'سكر وسط', 'سكر زيادة']
            }
          },
          {
            'name': 'سبانيش لاتيه بارد',
            'description': 'إسبريسو مع حليب مكثف محلى وثلج، طعم منعش وحلو.',
            'price': 4.00,
            'imageUrl': 'https://images.unsplash.com/photo-1517701550927-30cfcb64c5d4?auto=format&fit=crop&w=500&q=60',
            'category': 'قهوة باردة',
            'customizations': {
              'sizes': [{'name': 'وسط', 'price': 0.0}, {'name': 'كبير', 'price': 1.0}],
              'milk': ['حليب كامل الدسم', 'حليب خالي الدسم'],
              'sugar': ['بدون سكر', 'سكر وسط'] // الاسبانيش حلو بطبيعته
            }
          },
          {
            'name': 'كوكيز رقائق الشوكولاتة',
            'description': 'كوكيز مخبوز طازجاً محشو بقطع الشوكولاتة البلجيكية.',
            'price': 2.00,
            'imageUrl': 'https://images.unsplash.com/photo-1499636136210-6f4ee915583e?auto=format&fit=crop&w=500&q=60',
            'category': 'حلويات',
            'customizations': {} // الحلويات لا تحتاج تخصيص غالباً
          }
        ]
      },
      {
        'name': 'بلاك كوفي - Black Coffee',
        'imageUrl': 'https://images.unsplash.com/photo-1497935586351-b67a49e012bf?auto=format&fit=crop&w=500&q=60',
        'distance': 2.5,
        'isOpen': true,
        'menu': [
          {
            'name': 'في 60 - V60',
            'description': 'قهوة مقطرة يدوياً بحبوب مختصة من إثيوبيا.',
            'price': 4.50,
            'imageUrl': 'https://images.unsplash.com/photo-1495474472201-41164c760636?auto=format&fit=crop&w=500&q=60',
            'category': 'قهوة مقطرة',
            'customizations': {
              'sizes': [{'name': 'عادي', 'price': 0.0}],
              'beans': ['إثيوبي', 'كولومبي', 'برازيلي']
            }
          },
          {
            'name': 'أمريكانو',
            'description': 'شوت إسبريسو مع ماء ساخن.',
            'price': 2.50,
            'imageUrl': 'https://images.unsplash.com/photo-1551030173-122aabc4489c?auto=format&fit=crop&w=500&q=60',
            'category': 'قهوة ساخنة',
            'customizations': {
              'sizes': [{'name': 'صغير', 'price': 0.0}, {'name': 'وسط', 'price': 0.50}, {'name': 'كبير', 'price': 1.0}],
            }
          }
        ]
      },
      {
        'name': 'درايف ثرو كافيه - Drive Thru',
        'imageUrl': 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?auto=format&fit=crop&w=500&q=60',
        'distance': 5.0,
        'isOpen': false,
        'menu': [
          {
            'name': 'موكا مثلجة',
            'description': 'إسبريسو مع حليب، شوكولاتة، وثلج، مغطاة بالكريمة المخفوقة.',
            'price': 3.75,
            'imageUrl': 'https://images.unsplash.com/photo-1572442388796-11668aa44f26?auto=format&fit=crop&w=500&q=60',
            'category': 'قهوة باردة',
            'customizations': {
              'sizes': [{'name': 'وسط', 'price': 0.0}, {'name': 'كبير', 'price': 0.75}],
              'milk': ['حليب كامل', 'حليب خالي الدسم'],
            }
          }
        ]
      }
    ];

    try {
      // نبدأ برفع كل كافيه على حدة
      for (var shop in shopsData) {
        // 1. نستخرج المنيو من البيانات حتى لا يتم رفعه كـ Array داخل وثيقة الكافيه
        List<Map<String, dynamic>> menuItems = shop.remove('menu');

        // 2. نرفع الكافيه إلى مجموعة 'shops' ونحصل على الـ ID الخاص به
        DocumentReference shopRef = await _firestore.collection('shops').add(shop);

        // 3. نرفع المنتجات الخاصة بهذا الكافيه إلى مجموعة فرعية اسمها 'products' داخل الكافيه نفسه
        for (var item in menuItems) {
          await shopRef.collection('products').add(item);
        }
      }
      print('تم رفع الكافيهات والمنيو الخاص بها بنجاح! ✅☕');
    } catch (e) {
      print('حدث خطأ أثناء رفع البيانات: $e');
    }
  }
}