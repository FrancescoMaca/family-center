import 'package:flutter/material.dart';

class AppTheme {
  static double borderRadius = 15;

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFF837FC5),
    
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(
        color: Colors.black
      ),
      backgroundColor: Color(0xFF837FC5),
    ),
    
    textTheme: TextTheme(
      titleMedium: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: Colors.black
      ),
      titleSmall: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 21,
        fontWeight: FontWeight.normal,
        color: Colors.black
      ),
      bodyMedium: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 15,
        color: Colors.black
      ),
      bodySmall: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 12,
        color: Colors.grey.shade900
      )
    ),
    primaryColor: const Color(0xFF9F9BE4),
    primaryIconTheme: const IconThemeData(
      color: Colors.black
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: const WidgetStatePropertyAll(Color(0xFF9F9BE4)),
        shadowColor: const WidgetStatePropertyAll(Colors.transparent),
        side: const WidgetStatePropertyAll(
          BorderSide(
            color: Color(0xFF9F9BE4),
          )
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius)
          )
        )
      )
    )
  );

  static ThemeData darkTheme = lightTheme.copyWith(
    
    scaffoldBackgroundColor: const Color(0xFF403c75),
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(
        color: Colors.white
      ),
      backgroundColor: Color(0xFF403c75),
    ),
    textTheme: lightTheme.textTheme.copyWith(
      titleMedium: lightTheme.textTheme.titleMedium?.copyWith(
        color: Colors.white
      ),
      titleSmall: lightTheme.textTheme.titleSmall?.copyWith(
        color: Colors.white
      ),
      bodyMedium: lightTheme.textTheme.bodyMedium?.copyWith(
        color: Colors.white
      ),
      bodySmall: lightTheme.textTheme.bodySmall?.copyWith(
        color: Colors.grey
      ),
    ),
    primaryColor: const Color(0xFF555092),
    primaryIconTheme: const IconThemeData(
      color: Colors.white
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: lightTheme.elevatedButtonTheme.style?.copyWith(
        backgroundColor: const WidgetStatePropertyAll(Color(0xFF555092)),
        side: const WidgetStatePropertyAll(
          BorderSide(
            color: Color(0xFF555092),
          )
        ),
      )
    )
  );
}