import 'package:flutter/material.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

import 'package:imageurl_app/view/menu_button_screen.dart';

class FullscreenPage extends StatefulWidget {
  const FullscreenPage({super.key});

  @override
  FullscreenPageState createState() => FullscreenPageState();
}

class FullscreenPageState extends State<FullscreenPage> {
  final TextEditingController _urlController = TextEditingController();
  bool _isImageDisplayed = false;
  bool _isMenuOpen = false;
  bool _isFullscreen = false;
  html.ImageElement? _imgElement;

  /// Displays the image by appending an HTML ImageElement to the document body
  void displayImage() {
    String url = _urlController.text.trim();
    if (url.isNotEmpty) {
      // Remove the existing image if any
      _imgElement?.remove();

      // Create a new image element with styling
      _imgElement = html.ImageElement(src: url)
        ..style.position = 'absolute'
        ..style.left = '50%'
        ..style.top = '50%'
        ..style.borderRadius = '12px'
        ..style.transform = 'translate(-50%, -50%)'
        ..style.maxWidth = '100%'
        ..style.maxHeight = '90%'
        ..style.cursor = 'pointer';

      // Set a double-click event listener to toggle fullscreen mode
      _imgElement!.onDoubleClick.listen((event) {
        _toggleFullscreen();
      });

      // Append the image to the body
      html.document.body?.append(_imgElement!);

      setState(() {
        _isImageDisplayed = true;
      });
    }
  }

  /// Removes the displayed image from the screen
  void _removeImage() {
    _imgElement?.remove();
    setState(() {
      _isImageDisplayed = false;
    });
  }

  /// Toggles the fullscreen mode using JavaScript functions
  void _toggleFullscreen() {
    if (!_isFullscreen) {
      js.context.callMethod('eval', [
        '''
        if (document.documentElement.requestFullscreen) {
          document.documentElement.requestFullscreen();
        }
      '''
      ]);
    } else {
      js.context.callMethod('eval', [
        '''
        if (document.exitFullscreen) {
          document.exitFullscreen();
        }
      '''
      ]);
    }
    setState(() {
      _isFullscreen = !_isFullscreen;
    });
  }

  /// Builds a contextual floating menu with options
  Widget _buildContextMenu() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: _isMenuOpen ? 1.0 : 0.0,
      child: _isMenuOpen
          ? Stack(
              children: [
                // Background overlay to close the menu when tapped outside
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isMenuOpen = false;
                      });
                    },
                    child: Container(color: Colors.black54),
                  ),
                ),
                // Menu buttons
                Positioned(
                  right: 16,
                  bottom: 80,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      MenuButton(
                        icon: Icons.fullscreen,
                        label: 'Enter fullscreen',
                        onTap: () {
                          _toggleFullscreen();
                          setState(() {
                            _isMenuOpen = false;
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      MenuButton(
                        icon: Icons.fullscreen_exit,
                        label: 'Exit fullscreen',
                        onTap: () {
                          _toggleFullscreen();
                          setState(() {
                            _isMenuOpen = false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            )
          : const SizedBox.shrink(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromARGB(163, 27, 0, 228),
          Color.fromARGB(255, 182, 232, 255),
        ], begin: Alignment.topRight, end: Alignment.bottomRight)),
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Close button when the image is displayed
                    if (_isImageDisplayed)
                      Align(
                        alignment: Alignment.topRight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: _removeImage,
                          child: const Text('× Close'),
                        ),
                      ),

                    if (!_isImageDisplayed) ...[
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 2,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    Border.all(color: Colors.white, width: 0.5),
                                image: const DecorationImage(
                                    image: AssetImage(
                                        'images/WallpaperObjectsGroup (1).png'),fit: BoxFit.contain)),
                            child: const Center(
                                child: Text(
                              "Hello...",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 80,
                              
                                  fontWeight: FontWeight.w700),
                            )),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Text field to input image URL
                      TextField(
                        controller: _urlController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10),
                          labelText: 'Enter Image URL',
                          labelStyle: const TextStyle(color: Colors.black),
                          prefixIcon: const Icon(Icons.search,color: Colors.black,), // Added icon
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 0.5, color: Colors.white),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 1, color: Colors.black54),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          filled: true,
                          fillColor: Colors
                              .white54, // Background color inside the text field
                        ),
                        cursorColor: Colors.black, // Cursor color
                        style:
                            const TextStyle(color: Colors.black), // Text color
                      ),

                      const SizedBox(height: 10),
                      // Button to display image
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 80, vertical: 10),
                        ),
                        onPressed: displayImage,
                        child: const Text('Display Image',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                      ),
                      const SizedBox(height: 40),
                    ]
                  ],
                ),
              ),
            ),
            // Floating menu for fullscreen options
            _buildContextMenu(),
            // Floating button to toggle menu
            Positioned(
              right: 16,
              bottom: 16,
              child: FloatingActionButton(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                onPressed: () {
                  setState(() {
                    _isMenuOpen = !_isMenuOpen;
                  });
                },
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
