using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class mainmenuScript : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void startButtonPushed()
    {
        if(PlayerPrefs.GetFloat("tutorialComplete") != 1f)
        {
            SceneManager.LoadScene("tutorialscene");
        }
        if(PlayerPrefs.GetFloat("tutorialComplete") == 1f)
        {
            SceneManager.LoadScene("SampleScene");
        }
    }
}


//don't make me lal