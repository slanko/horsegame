using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
public class touchTheStupidFuckingPortalScript : MonoBehaviour
{
    //shutup i'm tired


    private void OnTriggerEnter(Collider other)
    {
        if(other.gameObject.tag == "Player")
        {
            SceneManager.LoadScene("SampleScene");
        }
    }

    //LAL
}
