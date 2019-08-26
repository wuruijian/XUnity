using UnityEngine;
using System.Collections;

public class ShadowScript : MonoBehaviour
{

	// Use this for initialization
	public Transform display;
	private GameObject ShadowCamera;
	private GameObject map;
	private RenderTexture mTex = null;
	public int Antialiasing = 4;

	void Start ()
	{
		map = transform.Find ("map").gameObject;
		ShadowCamera = transform.Find ("Camera").gameObject;
		if (!display)
			display = transform.parent;

		mTex = new RenderTexture (128, 128, 0);
		mTex.name = "shadow" + gameObject.GetInstanceID ();

		Camera mCamera = ShadowCamera.GetComponent<Camera> ();
		mCamera.cullingMask = GetLayerMask (display.gameObject.layer);
		mCamera.targetTexture = mTex;
	
	}


	public LayerMask GetLayerMask (int layer)
	{
		LayerMask mask = 0;
		mask |= 1 << layer;
		return mask;
	}
	
	// Update is called once per frame
	void Update ()
	{
	
//		if (display != null) {
//			mTex.antiAliasing = Antialiasing;
//		}

		map.GetComponent<Renderer> ().material.mainTexture = mTex;


	}
}
