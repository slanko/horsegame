using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class settingsScript : MonoBehaviour
{
    public Slider musicSlider, sfxSlider;
    // Start is called before the first frame update
    void Start()
    {
        musicSlider.value = PlayerPrefs.GetFloat("musicVolume", 0.1f);
        sfxSlider.value = PlayerPrefs.GetFloat("audioVolume", 1f);
        GameObject.Find("GOD").GetComponent<godScript>().muzik.volume = PlayerPrefs.GetFloat("musicVolume");
        GameObject.Find("GOD").GetComponent<godScript>().audioVolume = PlayerPrefs.GetFloat("audioVolume");
    }
    public void audioChange()
    {
        PlayerPrefs.SetFloat("audioVolume", sfxSlider.value);
        Debug.Log(PlayerPrefs.GetFloat("audioVolume"));
        if (SceneManager.GetActiveScene().name == "SampleScene" || SceneManager.GetActiveScene().name == "tutorialscene")
        {
            GameObject.Find("GOD").GetComponent<godScript>().audioVolume = PlayerPrefs.GetFloat("audioVolume");
        }
        PlayerPrefs.Save();
    }

    public void musicChange()
    {
        PlayerPrefs.SetFloat("musicVolume", musicSlider.value);
        if(SceneManager.GetActiveScene().name == "SampleScene" || SceneManager.GetActiveScene().name == "tutorialscene")
        {
            GameObject.Find("GOD").GetComponent<godScript>().muzik.volume = PlayerPrefs.GetFloat("musicVolume");
        }
        PlayerPrefs.Save();
    }

    public void deleteSavedata()
    {
        PlayerPrefs.DeleteAll();
    }



}

