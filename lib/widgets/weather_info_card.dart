
import 'package:flutter/material.dart';

class WeatherInfoCard extends StatelessWidget {
final IconData firstIcon;
final String firstValue;
final String firstLabel;
final IconData secondIcon;
final String secondValue;
final String secondLabel;
final Color firstIconColor;
final Color secondIconColor;

const WeatherInfoCard({
super.key,
required this.firstIcon,
required this.firstValue,
required this.firstLabel,
required this.secondIcon,
required this.secondValue,
required this.secondLabel,
required this.firstIconColor,
required this.secondIconColor,
});

@override
Widget build(BuildContext context) {
return Container(
margin: const EdgeInsets.only(bottom: 16),
child: Row(
children: [
Expanded(
child: _MetricCard(
icon: firstIcon,
iconColor: firstIconColor,
value: firstValue,
label: firstLabel,
),
),
const SizedBox(width: 12),
Expanded(
child: _MetricCard(
icon: secondIcon,
iconColor: secondIconColor,
value: secondValue,
label: secondLabel,
),
),
],
),
);
}
}

class _MetricCard extends StatelessWidget {
final IconData icon;
final Color iconColor;
final String value;
final String label;

const _MetricCard({
required this.icon,
required this.iconColor,
required this.value,
required this.label,
});

@override
Widget build(BuildContext context) {
return Container(
padding: const EdgeInsets.symmetric(
horizontal: 12,
vertical: 19,
),
decoration: BoxDecoration(
gradient: const LinearGradient(
begin: Alignment.topLeft,
end: Alignment.bottomRight,
colors: [
Color(0xB3233157),
Color(0xCC10182F),
Color(0xB30B1025),
],
stops: [0.0, 0.55, 1.0],
),
borderRadius: BorderRadius.circular(24),
border: Border.all(
color: const Color(0xFF8AAEFF).withValues(alpha:0.24),
width: 1,
),
boxShadow: [
BoxShadow(
color: iconColor.withValues(alpha:0.07),
blurRadius: 22,
spreadRadius: 0,
offset: const Offset(0, 5),
),
BoxShadow(
color: Colors.black.withValues(alpha:0.16),
blurRadius: 14,
offset: const Offset(0, 8),
),
],
),
child: Column(
children: [
Container(
width: 48,
height: 48,
decoration: BoxDecoration(
gradient: LinearGradient(
begin: Alignment.topLeft,
end: Alignment.bottomRight,
colors: [
iconColor.withValues(alpha:0.23),
iconColor.withValues(alpha:0.07),
],
),
shape: BoxShape.circle,
border: Border.all(
color: iconColor.withValues(alpha:0.42),
width: 1,
),
boxShadow: [
BoxShadow(
color: iconColor.withValues(alpha:0.12),
blurRadius: 14,
spreadRadius: 1,
),
],
),
child: Icon(
icon,
color: iconColor,
size: 24,
),
),
const SizedBox(height: 13),
Text(
value,
maxLines: 1,
overflow: TextOverflow.ellipsis,
style: const TextStyle(
fontSize: 21,
fontWeight: FontWeight.w700,
color: Color(0xFFF4F7FF),
letterSpacing: 0.2,
),
),
const SizedBox(height: 6),
Text(
label,
maxLines: 1,
overflow: TextOverflow.ellipsis,
textAlign: TextAlign.center,
style: const TextStyle(
fontSize: 12,
color: Color(0xFFB5C5E5),
fontWeight: FontWeight.w500,
letterSpacing: 0.3,
),
),
],
),
);
}
}
