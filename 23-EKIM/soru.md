Kullanıcı ekrandayken asenkron işlem başlar (await api.fetchSockets()). Kullanıcı cevap gelmeden geri tuşuna basıp sayfayı kapatır. BLoC/Cubit yok edildiği (closed) için hemen ardından gelen emit() satırı:

💥 StateError: Cannot emit new states after calling close

hatasını fırlatır ve uygulama çöker!

Çözüm: Asenkron await satırından sonraki her emit mutlaka şu şekilde korunmalıdır:
final data = await repository.getData();
if (!isClosed) {
  emit(DataLoaded(data));
}