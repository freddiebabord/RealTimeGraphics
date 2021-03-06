#pragma once

#include <tygra/WindowControlDelegate.hpp>

class MyView;

class MyController : public tygra::WindowControlDelegate
{
public:

    MyController();

    ~MyController();

private:

    void windowControlWillStart(tygra::Window * window) override;

    void windowControlDidStop(tygra::Window * window) override;

    void windowControlViewWillRender(tygra::Window * window) override;

    void windowControlMouseMoved(tygra::Window * window,
                                 int x,
                                 int y) override;

    void windowControlMouseButtonChanged(tygra::Window * window,
                                         int button_index,
                                         bool down) override;

    void windowControlMouseWheelMoved(tygra::Window * window,
                                      int position) override;

    void windowControlKeyboardChanged(tygra::Window * window,
                                      int key_index,
                                      bool down) override;

    void windowControlGamepadAxisMoved(tygra::Window * window,
                                       int gamepad_index,
                                       int axis_index,
                                       float pos) override;

    void windowControlGamepadButtonChanged(tygra::Window * window,
                                           int gamepad_index,
                                           int button_index,
                                           bool down) override;

    MyView * view_;
};
