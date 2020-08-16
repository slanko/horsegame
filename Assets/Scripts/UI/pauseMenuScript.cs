using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class pauseMenuScript : MonoBehaviour
{
    public GameObject pauseMenu, settingsMenu;

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Escape))
        {
            if(pauseMenu.activeSelf == true)
            {
                closeMenu();
            }
            else
            {
                openMenu();
            }
        }
    }

    public void closeMenu()
    {
        pauseMenu.SetActive(false);
        settingsMenu.SetActive(false);
        Time.timeScale = 1;
        Cursor.lockState = CursorLockMode.Locked;
        Cursor.visible = false;
    }

    public void openMenu()
    {
        pauseMenu.SetActive(true);
        settingsMenu.SetActive(false);
        Time.timeScale = 0;
        Cursor.lockState = CursorLockMode.None;
        Cursor.visible = true;
    }

    public void openSettingsMenu()
    {
        settingsMenu.SetActive(true);
    }

    public void closeSettingsMenu()
    {
        settingsMenu.SetActive(false);
    }

    public void returnToMainMenu()
    {
        SceneManager.LoadScene("Title");
    }
}
