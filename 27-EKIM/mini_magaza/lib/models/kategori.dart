enum Kategori{ // Kategori enum yapısı, belirli sabit seçenekleri tip güvenli şekilde listelememizi sağlar
    hepsi('Tümü','H'),
    elektronik('Elektronik','E'),
    giyim('Giyim','G'),
    ayakkabi('Ayakkabı','A'),
    aksesuar('Aksesuar','AK');

    final String baslik; // String türünden baslik adlı değişkenimiz
    final String ikon; // String türünden ikon adlı değişkenimiz

    const Kategori(this.baslik,this.ikon); // baslik alanına değer aktarıyoruz
}

