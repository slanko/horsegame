using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class spinCameraScript : MonoBehaviour
{
    public GameObject normalCam, spinCam;
    characterController cC;

    private void Start()
    {
        cC = GetComponent<characterController>();
    }
    // Update is called once per frame
    void Update()
    {
        if(cC.currentState == characterController.playerState.TAMING || cC.currentState == characterController.playerState.RAGDOLL)
        {
            spinCam.SetActive(true);
        }
        else
        {
            spinCam.SetActive(false);
        }
    }
}
