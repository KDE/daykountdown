#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <KXmlGuiWindow>

// Generic text editing widget
class KTextEdit;

// Subclassing KXmlGuiWindow
// Derived class : Base class
class MainWindow : public KXmlGuiWindow {
    public: 
        // Declaring constructor
        explicit MainWindow(QWidget *parent = nullptr);
        
    private:
        // Pointer to the object
        KTextEdit *textArea;
        void setupActions();
};

#endif // MAINWINDOW_H
