using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class openMenu : MonoBehaviour
{
    public GameObject diary;
    bool menuUp;
    public string boardName;
    public GameObject myPipe;
    horseListScript hLS;
    // Start is called before the first frame update
    void Start()
    {
        diary.SetActive(false);
        Cursor.lockState = CursorLockMode.Locked;
        Cursor.visible = false;
        hLS = GameObject.Find("GOD").GetComponent<horseListScript>();
    }
    public void openTheMenu()
    {
        diary.SetActive(true);
        Cursor.lockState = CursorLockMode.None;
        Cursor.visible = true;
        hLS.currentPipe = myPipe;
    }

    public void closeTheMenu()
    {
        diary.SetActive(false);
        Cursor.lockState = CursorLockMode.Locked;
        Cursor.visible = false;
    }
}
