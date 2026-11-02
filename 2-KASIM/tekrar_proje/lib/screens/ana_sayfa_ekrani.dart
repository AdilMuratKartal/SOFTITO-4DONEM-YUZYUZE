class AnaSayfa extends StatelessWidget{
    const AnaSayfa({super.key});

    @override
    Widget build(BuildContext context){
        return Scaffold(
            appBar: AppBar(),
            body: Column(
                crossAxisAlignment : CrossAxisAlignment.center,
                children:[
                    Card(),
                    Card(),
                    Card(),
                ]
            )
        )
    }
}