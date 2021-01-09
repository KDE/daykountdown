#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <KXmlGuiWindow>

// Generic text editing widget
class KTextEdit;

// Subclassing KXmlGuiWindow
class MainWindow : public KXmlGuiWindow {
    public: 
        // Declaring constructor
        explicit MainWindow(QWidget *parent = nullptr);
        
    private:
        // Pointer to the object
        KTextEdit *textArea;
};

#endif // MAINWINDOW_H
